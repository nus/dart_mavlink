library dart_mavlink;

import 'dart:typed_data';

import 'package:dart_mavlink/mavlink_message.dart';

abstract class MavlinkDialect {
  int get version;

  MavlinkMessage? parse(int messageID, ByteData data);

  /// Returns CRC Extra of messageID. Returns -1 if unsupported messageID.
  int crcExtra(int messageID);
}
