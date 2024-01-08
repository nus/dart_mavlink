import 'dart:typed_data';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:test/test.dart';

void main() {

  setUp(() {
  });

  test('Serialize v1 packet', () async {
    var v = "FAKE_PARAM".codeUnits + [0, 0, 0, 0, 0, 0];
    Uint8List.fromList(v);
    var msg = ParamSet(targetSystem: 1,
             targetComponent: 2,
             paramId: v,
             paramValue: 3,
             paramType: mavParamTypeInt32);
    var s = msg.serialize();
    expect([
      0, 0, 64, 64, // param_value
      1,            // target_system
      2,            // target_component
      70, 65, 75, 69, 95, 80, 65, 82, 65, 77, 0, 0, 0, 0, 0, 0, // param_value
      6],           // param_type
      s.buffer.asUint8List());
  });
}
