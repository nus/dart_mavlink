library dart_mavlink;

import 'package:dart_mavlink/crc.dart';

import 'mavlink_version.dart';
import 'mavlink_message.dart';
import 'dart:typed_data';

class MavlinkFrame {
  static const mavlinkStxV1 = 0xFE;
  static const mavlinkStxV2 = 0xFD;

  final MavlinkVersion version;
  final int sequence;
  final int systemId;
  final int componentId;
  MavlinkMessage message;
  MavlinkFrame(this.version, this.sequence, this.systemId, this.componentId, this.message);

  /// Create MavlinkFrame for MAVLink version1.
  factory MavlinkFrame.v1(int sequence, int systemId, int componentId, MavlinkMessage message) {
    return MavlinkFrame(MavlinkVersion.v1, sequence, systemId, componentId, message);
  }

  /// Create MavlinkFrame for MAVLink version2.
  factory MavlinkFrame.v2(int sequence, int systemId, int componentId, MavlinkMessage message) {
    return MavlinkFrame(MavlinkVersion.v2, sequence, systemId, componentId, message);
  }

  Uint8List serialize() {
    if (version == MavlinkVersion.v1) {
      return _serializeV1();
    } else {
      return _serializeV2();
    }
  }

  Uint8List _serializeV1() {
    if (version != MavlinkVersion.v1) {
      throw UnsupportedError('Unexpected MAVLink version($version)');
    }

    var payload = message.serialize();
    var payloadLength = payload.lengthInBytes;

    var bytes = ByteData(8 + payloadLength);
    bytes.setUint8(0, mavlinkStxV1);
    bytes.setUint8(1, payloadLength);
    bytes.setUint8(2, sequence);
    bytes.setUint8(3, systemId);
    bytes.setUint8(4, componentId);
    bytes.setUint8(5, message.mavlinkMessageId);

    var crc = CrcX25();
    crc.accumulate(payloadLength);
    crc.accumulate(sequence);
    crc.accumulate(systemId);
    crc.accumulate(componentId);
    crc.accumulate(message.mavlinkMessageId);

    var payloadBytes = payload.buffer.asUint8List();
    for (var i = 0; i < payloadLength; i++) {
      bytes.setUint8(6 + i, payloadBytes[i]);
      crc.accumulate(payloadBytes[i]);
    }
    crc.accumulate(message.mavlinkCrcExtra);

    bytes.setUint8(bytes.lengthInBytes - 2, crc.crc & 0xff);
    bytes.setUint8(bytes.lengthInBytes - 1, (crc.crc >> 8) & 0xff);

    return bytes.buffer.asUint8List();
  }

  Uint8List _serializeV2() {
    if (version != MavlinkVersion.v2) {
      throw UnsupportedError('Unexpected MAVLink version($version)');
    }

    int incompatibilityFlags = 0;
    int compatibilityFlags = 0;
    var payload = message.serialize();
    var payloadBytes = payload.buffer.asUint8List().sublist(0);

    // Truncate any zero's off of the payload. Can't be shorter than 1 byte even if all zeros
    while(payloadBytes.length > 1){
      if(payloadBytes.last == 0x00){
        payloadBytes = payloadBytes.sublist(0, payloadBytes.length - 1);
      }
      else {
        break;
      }
    }
    var payloadLength = payloadBytes.length;
    var messageIdBytes = [
      message.mavlinkMessageId & 0xff,
      (message.mavlinkMessageId >> 8) & 0xff,
      (message.mavlinkMessageId >> 16) & 0xff
    ];

    var bytes = ByteData(12 + payloadLength);
    bytes.setUint8(0, mavlinkStxV2);
    bytes.setUint8(1, payloadLength);
    bytes.setUint8(2, incompatibilityFlags);
    bytes.setUint8(3, compatibilityFlags);
    bytes.setUint8(4, sequence);
    bytes.setUint8(5, systemId);
    bytes.setUint8(6, componentId);
    bytes.setUint8(7, messageIdBytes[0]);
    bytes.setUint8(8, messageIdBytes[1]);
    bytes.setUint8(9, messageIdBytes[2]);
    for(int i = 0; i < payloadLength; i++){
      bytes.setUint8(10 + i, payloadBytes[i]);
    }

    var crc = CrcX25();
    crc.accumulate(payloadLength);
    crc.accumulate(incompatibilityFlags);
    crc.accumulate(compatibilityFlags);
    crc.accumulate(sequence);
    crc.accumulate(systemId);
    crc.accumulate(componentId);
    crc.accumulate(messageIdBytes[0]);
    crc.accumulate(messageIdBytes[1]);
    crc.accumulate(messageIdBytes[2]);
    for(final byte in payloadBytes){
      crc.accumulate(byte);
    }
    crc.accumulate(message.mavlinkCrcExtra);

    bytes.setUint8(bytes.lengthInBytes - 2, crc.crc & 0xff);
    bytes.setUint8(bytes.lengthInBytes - 1, (crc.crc >> 8) & 0xff);

    return bytes.buffer.asUint8List();
  }
}
