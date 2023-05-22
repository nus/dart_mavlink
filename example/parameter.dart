import 'dart:io';

import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

void main() async {
  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);

  parser.stream.listen((MavlinkFrame frm) {
    if (frm.message is ParamValue) {
      var paramValue = frm.message as ParamValue;

      var terminatedIndex = paramValue.paramId.indexOf(0);
      terminatedIndex = terminatedIndex == -1 ? paramValue.paramId.length : terminatedIndex;
      var trimmed = paramValue.paramId.sublist(0, terminatedIndex);
      var paramId = String.fromCharCodes(trimmed);

      print('paramValue: ${paramValue.paramIndex} $paramId');
    }
  }); 

  var sequence = 0;
  var systemId = 255;
  var componentId = 1;
  var requestedParam = false;
  var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 14550);
  socket.listen((RawSocketEvent e) {
    if (e != RawSocketEvent.read) {
      return;
    }

    Datagram? d = socket.receive();
    if (d == null) {
      return;
    }

    parser.parse(d.data);

    if (!requestedParam) {
      var paramRequestList = ParamRequestList(
        targetSystem: 1,
        targetComponent: 1
      );
      var frm = MavlinkFrame.v1(sequence, systemId, componentId, paramRequestList);
      socket.send(frm.serialize(), d.address, d.port);

      requestedParam = true;
    }
  });
}
