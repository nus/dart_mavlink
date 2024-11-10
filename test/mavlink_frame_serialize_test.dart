import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink_frame.dart';
import 'package:dart_mavlink/mavlink_version.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {});

  test('Serialize full v2 frame with extension fields', () async {
    // In this message mission type is an extension field
    var msg = MissionRequestList(targetSystem: 1, targetComponent: 2, missionType: 3);
    var frame = MavlinkFrame(MavlinkVersion.v2, 0, 255, 190, msg);
    var frameSerialized = frame.serialize();
    var expectedBytes = [253, 3, 0, 0, 0, 255, 190, 43, 0, 0, 1, 2, 3, 243, 192];
    expect(expectedBytes, frameSerialized.buffer.asUint8List());
  });

  test('Serialize full v2 frame with extension fields, last value set to 0 to test truncation', () async {
    // In this message mission type is an extension field, set to 0 to test truncation
    var msg = MissionRequestList(targetSystem: 1, targetComponent: 2, missionType: 0);
    var frame = MavlinkFrame(MavlinkVersion.v2, 0, 255, 190, msg);
    var frameSerialized = frame.serialize();
    var expectedBytes = [253, 2, 0, 0, 0, 255, 190, 43, 0, 0, 1, 2, 192, 186];
    expect(expectedBytes, frameSerialized.buffer.asUint8List());
  });

  test('Serialize full v2 frame with extension fields, all values set to 0 to test over-truncation', () async {
    // all values set to zero in message body, the first 0 byte should be retained
    var msg = MissionRequestList(targetSystem: 0, targetComponent: 0, missionType: 0);
    var frame = MavlinkFrame(MavlinkVersion.v2, 0, 255, 190, msg);
    var frameSerialized = frame.serialize();
    var expectedBytes = [253, 1, 0, 0, 0, 255, 190, 43, 0, 0, 0, 158, 53];
    expect(expectedBytes, frameSerialized.buffer.asUint8List());
  });

  test("Serialize large message with lots of 0 truncated bytes", () async {
    var msg = FileTransferProtocol(targetNetwork: 1, targetSystem: 2, targetComponent: 3, payload: [30, 30, 30, 30, 30, 30, 30, 30, 30, 30]);
    var frame = MavlinkFrame(MavlinkVersion.v2, 0, 255, 190, msg);
    var frameSerialized = frame.serialize();
    var expectedBytes = [253, 13, 0, 0, 0, 255, 190, 110, 0, 0, 1, 2, 3, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 141, 124];
    expect(expectedBytes, frameSerialized);
  });
}
