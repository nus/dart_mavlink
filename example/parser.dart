import 'dart:io';
import 'dart:math';

import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

void main() {
  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);

  parser.stream.listen((MavlinkFrame frm) {
    if (frm.message is Attitude) {
      var attitude = frm.message as Attitude;
      print('Yaw: ${attitude.yaw / pi * 180} [deg]');
    }
  });

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 14550).then((RawDatagramSocket socket) {
    print('Listening.');

    socket.listen((RawSocketEvent e) {
      if (e != RawSocketEvent.read) {
        return;
      }

      Datagram? d = socket.receive();
      if (d == null) {
        return;
      }

      parser.parse(d.data);
    });
  });
}
