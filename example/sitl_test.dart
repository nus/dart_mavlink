import 'dart:io';
import 'dart:math';
import 'dart:convert' show ascii, AsciiEncoder;
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

const myComponentId = mavTypeGcs;
const mySystemId = 255;
int sequence = 0;
Socket? sitlSocket;

void main() async {
  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);
  sitlSocket = await Socket.connect("127.0.0.1", 5760);
  print("Connected to socket");

  parser.stream.listen((MavlinkFrame frame) {
    var message = frame.message;
    var messageType = frame.message.runtimeType;
    print(
        "Got $messageType from System: ${frame.systemId} Component: ${frame.componentId}");
    switch (messageType) {
      case Heartbeat:
        handleHeartbeat(message as Heartbeat);
        break;
      case Statustext:
        handleStatusText(message as Statustext);
        break;
    }
  });

  sitlSocket?.listen((data) {
    parser.parse(data);
  }, onError: (error) {
    print("Error $error when listening. Exiting.");
    exit(0);
  }, onDone: () {
    print("Socket closed, Exiting!");
    exit(0);
  });

  Future.delayed(Duration(seconds: 5)).then((_) {
    sendHeartbeat();
    sendArmCommand();
  });
}

void sendMessage(MavlinkMessage msg) {
  var frame = MavlinkFrame.v2(sequence, mySystemId, myComponentId, msg);
  sitlSocket?.add(frame.serialize());
  sequence = (sequence == 255) ? 0 : sequence + 1;
}

void sendHeartbeat() {
  print("Sending a heartbeat");
  Heartbeat heartbeat = Heartbeat(
      type: mavTypeGeneric,
      autopilot: mavAutopilotGeneric,
      baseMode: 0,
      customMode: 0,
      systemStatus: mavStateActive,
      mavlinkVersion: 2);
  sendMessage(heartbeat);
}

void sendArmCommand() {
  print("Sending arm command");
  var command = CommandLong(
      command: mavCmdComponentArmDisarm,
      param1: 1,
      param2: 0,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0,
      targetSystem: 1,
      targetComponent: 1,
      confirmation: 0);
  sendMessage(command);
}

void handleHeartbeat(Heartbeat msg) {
  print("handling a heartbeat! System type is ${msg.type}");
}

void handleStatusText(Statustext msg) {
  print("Handle Statustext");
  print(convertMavlinkCharListToString(msg.text));
}

String convertMavlinkCharListToString(List<int>? charList) {
  if (charList == null) {
    return "";
  }
  // The P2 sends char array initalized with 0x00, throw away any "characters" that match that
  List<int> trimmedName = [];
  for (int character in charList) {
    if (character != 0x00 && character > 0) {
      trimmedName.add(character);
    }
  }
  return ascii.decode(trimmedName);
}