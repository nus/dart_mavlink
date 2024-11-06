import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink_parser.dart';
import 'package:dart_mavlink/mavlink_version.dart';
import 'package:test/test.dart';
import 'dart:typed_data';

void main() {
  MavlinkParser? parser;
  var d = Uint8List.fromList([
    0xfd, // Magick Number V2
    0x09, // Payload Length
    0x00, // Incompatibility Flags
    0x00, // Compatibility Flags
    0xdf, // Packet Sequence
    0x01, // System ID
    0x01, // Component ID
    0x00, // Message ID,low (HEARTBEAT)
    0x00, // Message ID,middle
    0x00, // Message ID,hight
    0x00, 0x00, 0x04, 0x03, // Custom Mode
    0x02, // Type
    0x0c, // autopilot
    0x1d, // base mode
    0x03, // system status
    0x03, // mavlink version
    // End of payload
    0x35, 0x36 // Checksum (Low byte, High byte)
  ]);

  setUp(() {
    parser = MavlinkParser(MavlinkDialectCommon());
  });

  test('Parse V2 packet', () async {
    parser!.parse(d);
    var frm = await parser!.stream.first;

    expect(frm.version, MavlinkVersion.v2);
    expect(frm.sequence, 0xdf);
    expect(frm.systemId, 0x01);
    expect(frm.componentId, 0x01);
    expect(frm.message is Heartbeat, isTrue);
    var hb = frm.message as Heartbeat;
    expect(hb.customMode, 0x03040000);
    expect(hb.type, mavTypeQuadrotor);
    expect(hb.autopilot, 0x0C);
    expect(hb.baseMode, 0x1D);
    expect(hb.systemStatus, 0x03);
    expect(hb.mavlinkVersion, 0x03);

    var ser = frm.serialize();
    for (int i = 0; i < d.length; i++) {
      expect(d[i], ser[i]);
    }

    var hbModified = hb.copyWith(type: mavTypeFixedWing);
    expect(hbModified.type, mavTypeFixedWing);
    expect(hbModified.autopilot, 0x0C);
  });

  test('Parse BATTERY_STATUS', () async {
    var d = Uint8List.fromList([
      0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xd2, 0x0f, 0xd2, 0x0f, 0xd2, 0x0f,
      0xd2, 0x0f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9c, 0xff,
      0x00, 0x01, 0x01, 0x64, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
      0xff
    ]);
    var bs = BatteryStatus.parse(d.buffer.asByteData());
    expect(bs.currentConsumed, 0);
    expect(bs.energyConsumed, -1);
    expect(bs.temperature, 32767);
    expect(bs.voltages[0], 4050);
    expect(bs.voltages[1], 4050);
    expect(bs.voltages[2], 4050);
    expect(bs.voltages[3], 4050);
    expect(bs.voltages[4], 65535);
    expect(bs.voltages[5], 65535);
    expect(bs.voltages[6], 65535);
    expect(bs.voltages[7], 65535);
    expect(bs.voltages[8], 65535);
    expect(bs.voltages[9], 65535);
    expect(bs.currentBattery, -100);
    expect(bs.batteryFunction, 1);
    expect(bs.type, 1);
    expect(bs.batteryRemaining, 100);
    expect(bs.voltagesExt[0], 65535);
    expect(bs.voltagesExt[1], 65535);
    expect(bs.voltagesExt[2], 65535);
    expect(bs.voltagesExt[3], 65535);
    expect(bs.mode, 0);
    expect(bs.faultBitmask, 0);

    var serialized = bs.serialize().buffer.asUint8List();
    for (var i = 0; i < d.length; i++) {
      expect(serialized[i], d[i]);
    }
  });
}
