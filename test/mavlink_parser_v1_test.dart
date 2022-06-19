import 'dart:async';

import 'package:dart_mavlink/mavlink_parser.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:test/test.dart';
import 'dart:typed_data';

void main() {
  MavlinkParser? parser;
  var d = Uint8List.fromList([
    0xFE, // Magick Number V1
    0x09, // Payload Length
    0xD2, // Packet Sequence
    0x01, // System ID
    0x01, // Component ID
    0x00, // Message ID (HEARTBEAT)
      // Begin of payload
    0x00, 0x00, 0x04, 0x03, // Custom Mode
    0x02, // Type
    0x0C, // autopilot
    0x1D, // base mode
    0x03, // system status
    0x03, // mavlink version
    // End of payload
    0x05, 0xEA // Checksum (Low byte, High byte)
  ]);

  setUp(() {
    parser = MavlinkParser(MavlinkDialectCommon());
  });

  test('Parse V1 packet', () async {
    parser!.parse(d);
    var frm = await parser!.stream.first;

    expect(frm.sequence, 0xD2);
    expect(frm.systemId, 0x01);
    expect(frm.componentId, 0x01);
    expect(frm.message is Heartbeat, isTrue);
    var hb = frm.message as Heartbeat;
    expect(hb.customMode, 0x03040000);
    expect(hb.type, mavTypeQuadrotor);
    expect(hb.autopilot, mavAutopilotPx4);
    expect(hb.baseMode, 0x1D);
    expect(hb.systemStatus, 0x03);
    expect(hb.mavlinkVersion, 0x03);

    var ser = frm.serialize();
    for (int i = 0; i < d.length; i++) {
      expect(d[i], ser[i]);
    }
  });

  test('Parse chuncked V1 packet', () async {
    var mid = d.length ~/ 2;
    var c1 = d.sublist(0, mid);
    var c2 = d.sublist(mid);

    parser!.parse(c1);
    parser!.parse(c2);

    var frm = await parser!.stream.first;
    expect(frm.sequence, 0xD2);
    expect(frm.systemId, 0x01);
    expect(frm.componentId, 0x01);
    expect(frm.message is Heartbeat, isTrue);
  });

  test('Parse V1 packet with bad CRC', () async {
    var badCRC = Uint8List.fromList(d);
    badCRC[badCRC.length - 2] = 0x0B;
    badCRC[badCRC.length - 1] = 0xAD;
    parser!.parse(badCRC);

    var s = parser!.stream.timeout(Duration(milliseconds: 300));
    expect(() async => await s.first, throwsA(TypeMatcher<TimeoutException>()));
  });

  test('Parse a MAVLink packet contains float array', () async {
    var d = Uint8List.fromList([
      // Header
      0xfe, // Magick Number V1
      0x29, // Payload Length
      0x8b, // Packet Sequence
      0x01, // System ID
      0x01, // Component ID
      0x8c, // Message ID (ACTUATOR_CONTROL_TARGET)
      // Begin of payload
      0xe0, 0x8a, 0x1a, 0x07, 0x00, 0x00, 0x00, 0x00, // time_usec
      0xda, 0x8d, 0xc5, 0xba, // controls[0]
      0xc4, 0x50, 0x8c, 0x3a, // controls[1]
      0x83, 0xbe, 0xa5, 0x39, // controls[2]
      0x6f, 0x12, 0x83, 0x3a, // controls[3]
      0x00, 0x00, 0x00, 0x00, // controls[4]
      0x00, 0x00, 0x00, 0x00, // controls[5]
      0x00, 0x00, 0x00, 0x00, // controls[6]
      0x00, 0x00, 0x80, 0xbf, // controls[7]
      0x00, // group_mlx
    // End of payload
      0x31, 0x14  // Checksum (Low byte, High byte)
    ]);
    parser!.parse(d);

    var frm = await parser!.stream.first;
    expect(frm.sequence, 0x8b);
    expect(frm.systemId, 0x01);
    expect(frm.componentId, 0x01);
    expect(frm.message is ActuatorControlTarget, isTrue);
    var act = frm.message as ActuatorControlTarget;
    expect(act.timeUsec, 0x00000000071a8ae0);
    expect(act.controls[0], -0.0015072182286530733);
    expect(act.controls[1], 0.0010705222375690937);
    expect(act.controls[2], 0.00031613194732926786);
    expect(act.controls[3], 0.0010000000474974513);
    expect(act.controls[4], 0.0);
    expect(act.controls[5], 0.0);
    expect(act.controls[6], 0.0);
    expect(act.controls[7], -1.0);
    expect(act.groupMlx, 0x00);

    var byteData = act.serialize();
    for (var i = 0; i < 41; i++) {
      expect(byteData.getUint8(i), d[6 + i]);
    }
  });
}
