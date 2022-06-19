library dart_mavlink;

import 'dart:async';
import 'dart:typed_data';

import 'crc.dart';
import 'mavlink_dialect.dart';
import 'mavlink_frame.dart';
import 'mavlink_version.dart';

enum _ParserState {
  init,
  waitPayloadLength,
  waitIncompatibilityFalgs,
  waitCompatibilityFlags,
  waitPacketSequence,
  waitSystemId,
  waitComponentId,
  waitMessageIdLow,
  waitMessageIdMiddle,
  waitMessageIdHigh,
  waitPayloadEnd,
  waitCrcLowByte,
  waitCrcHighByte,
}

class MavlinkParser {
  static const _mavlinkMaximumPayloadSize = 255;
  static const _mavlinkIflagSigned = 0x01;

  final _streamController = StreamController<MavlinkFrame>();

  _ParserState _state = _ParserState.init;

  MavlinkVersion _version = MavlinkVersion.v1;
  int _payloadLength = -1;
  int _incompatibilityFlags = -1;
  int _compatibilityFlags = -1;
  int _sequence = -1;
  int _systemId = -1;
  int _componentId = -1;
  int _messageIdLow = -1;
  int _messageIdMiddle = -1;
  int _messageIdHigh = -1;
  int _messageId = -1;
  final Uint8List _payload = Uint8List(_mavlinkMaximumPayloadSize);
  int _payloadCursor = -1;
  int _crcLowByte = -1;
  int _crcHighByte = -1;

  final MavlinkDialect _dialect;

  MavlinkParser(this._dialect);

  void _resetContext() {
    _version = MavlinkVersion.v1;
    _payloadLength = -1;
    _incompatibilityFlags = -1;
    _compatibilityFlags = -1;
    _sequence = -1;
    _systemId = -1;
    _componentId = -1;
    _messageIdLow = -1;
    _messageIdMiddle = -1;
    _messageIdHigh = -1;
    _messageId = -1;
    _payloadCursor = -1;
    _crcLowByte = -1;
    _crcHighByte = -1;
  }

  bool _checkCRC() {
    var header = (_version == MavlinkVersion.v1)
      ? [_payloadLength, _sequence, _systemId, _componentId, _messageId]
      : [_payloadLength, _incompatibilityFlags, _compatibilityFlags, _sequence, _systemId, _componentId, _messageIdLow, _messageIdMiddle, _messageIdHigh];

    var crc = CrcX25();

    for (int d in header) {
      crc.accumulate(d & 0xff);
    }

    for (int i = 0; i < _payloadLength; i++) {
      var d = _payload[i];
      crc.accumulate(d & 0xff);
    }

    var crcExt = _dialect.crcExtra(_messageId);
    if (crcExt == -1) {
      return false;
    }
    crc.accumulate(crcExt);

    return crc.crc == ((_crcHighByte) << 8) ^ (_crcLowByte);
  }

  void parse(Uint8List data) {
    for (int d in data) {
      switch (_state) {
      case _ParserState.init:
        switch (d) {
        case MavlinkFrame.mavlinkStxV1:
          _version = MavlinkVersion.v1;
          _state = _ParserState.waitPayloadLength;
          break;
        case MavlinkFrame.mavlinkStxV2:
          _version = MavlinkVersion.v2;
          _state = _ParserState.waitPayloadLength;
          break;
        default:
          // Skip the byte
        }
        break;
      case _ParserState.waitPayloadLength:
        _payloadLength = d;
        if (_version == MavlinkVersion.v1) {
          _state = _ParserState.waitPacketSequence;
        } else {
          // For MAVLink v2
          _state = _ParserState.waitIncompatibilityFalgs;
        }
        break;
      case _ParserState.waitIncompatibilityFalgs:
        // For MAVLink v2
        _incompatibilityFlags = d;
        _state = _ParserState.waitCompatibilityFlags;
        break;
      case _ParserState.waitCompatibilityFlags:
        // For MAVLink v2
        _compatibilityFlags = d;
        _state = _ParserState.waitPacketSequence;
        break;
      case _ParserState.waitPacketSequence:
        _sequence = d;
        _state = _ParserState.waitSystemId;
        break;
      case _ParserState.waitSystemId:
        _systemId = d;
        _state = _ParserState.waitComponentId;
        break;
      case _ParserState.waitComponentId:
        _componentId = d;
        if (_version == MavlinkVersion.v1) {
          _state = _ParserState.waitMessageIdHigh;
        } else {
          _state = _ParserState.waitMessageIdLow;
        }
        break;
      case _ParserState.waitMessageIdLow:
        // For MAVLink v2
        _messageIdLow = d;
        _state = _ParserState.waitMessageIdMiddle;
        break;
      case _ParserState.waitMessageIdMiddle:
        // For MAVLink v2
        _messageIdMiddle = d;
        _state = _ParserState.waitMessageIdHigh;
        break;
      case _ParserState.waitMessageIdHigh:
        if (_version == MavlinkVersion.v1) {
          _messageId = d;
        } else {
          // For MAVLink v2
          _messageIdHigh = d;
          _messageId = (_messageIdHigh << 16) ^ (_messageIdMiddle << 8) ^ _messageIdLow;
        }

        if (_payloadLength == 0) {
          _state = _ParserState.waitCrcLowByte;
        } else {
          _state = _ParserState.waitPayloadEnd;
          _payloadCursor = 0;
        }
        break;
      case _ParserState.waitPayloadEnd:
        if (_payloadCursor < _payloadLength) {
          _payload[_payloadCursor++] = d;
        }

        if (_payloadCursor == _payloadLength) {
          _state = _ParserState.waitCrcLowByte;
        }
        break;
      case _ParserState.waitCrcLowByte:
        _crcLowByte = d;
        _state = _ParserState.waitCrcHighByte;
        break;
      case _ParserState.waitCrcHighByte:
        _crcHighByte = d;

        if (_version == MavlinkVersion.v2) {
          if (_incompatibilityFlags == _mavlinkIflagSigned) {
            // TODO Handle the Signature bits.
            _resetContext();
            _state = _ParserState.init;
            break;
          }
        }

        _addMavlinkFrameToStream();

        _resetContext();
        _state = _ParserState.init;
        break;
      }
    }
  }

  bool _addMavlinkFrameToStream() {
    // check CRC bytes.
    if (!_checkCRC()) {
      // The MAVLink packet is a bad CRC.
      // Ignore the MAVLink packet.
      return false;
    }

    var message = _dialect.parse(_messageId, _payload.buffer.asByteData(0, _payloadLength));
    if (message == null) {
      return false;
    }

    // Got a Mavlink Frame data.
    var frame = MavlinkFrame(_version, _sequence, _systemId, _componentId, message);
    _streamController.add(frame);
    return true;
  }

  Stream<MavlinkFrame> get stream => _streamController.stream;
}
