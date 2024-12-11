import 'dart:io';
import 'dart:async';
import 'dart:convert' show ascii;
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

const myComponentId = mavTypeGcs;
const mySystemId = 255;
int sequence = 0;
Socket? sitlSocket;
SysStatus? lastSysStatus;
Heartbeat? lastHeartbeat;
VfrHud? lastVfrHud;
Attitude? lastAttitude;
GlobalPositionInt? lastGlobalPositionInt;
bool ardupilotReady = false;

void main() async {
  var dialect = MavlinkDialectCommon(); // Declare which dialect we're going to use
  var parser = MavlinkParser(dialect); // Create the parser with the selected dialect
  sitlSocket = await Socket.connect("127.0.0.1", 5760); // Connect to the device. TCP in this case

  // Configure the socket to pass it's received data to the parser
  sitlSocket?.listen((data) {
    parser.parse(data);
  }, onError: (error) {
    print("Error $error when listening. Exiting.");
    exit(0);
  }, onDone: () {
    print("Socket closed, Exiting!");
    exit(0);
  });

  // The parser has a Stream object that emits MavlinkFrames whenever it successfully parses a frame
  // Here we setup callbacks to do actions based on what type of MavlinkMessage is in the message field of the frame
  // See https://mavlink.io/en/guide/serialization.html#mavlink2_packet_format for more info on what info is in the frame vs. the message.
  parser.stream.listen((MavlinkFrame frame) {
    MavlinkMessage message = frame.message;
    var messageType = frame.message.runtimeType;
    switch (messageType) {
      case Heartbeat:
        handleHeartbeat(message as Heartbeat);
        break;
      case Statustext:
        handleStatusText(message as Statustext);
        break;
      case CommandAck:
        handleCommandAck(message as CommandAck);
        break;
      case SysStatus:
        lastSysStatus = message as SysStatus;
        break;
      case VfrHud:
        lastVfrHud = message as VfrHud;
        break;
      case GlobalPositionInt:
        lastGlobalPositionInt = message as GlobalPositionInt;
        break;
      default:
      // print("Got $messageType from System: ${frame.systemId} Component: ${frame.componentId}");
    }
  });

  // Setup a timer to periodically send a heartbeat to the simulated device, as well as print out some info
  Timer.periodic(Duration(seconds: 1), (_) {
    sendHeartbeat();
    printSystemState();
  });

  // Wait for Ardupilot to boot up. handleStatusText will set the bool when it hears that APM is ready.
  // Theres probably a more elegent way to check for this but this works for demonstration.
  await Future.doWhile(() async {
    await Future.delayed(Duration(seconds: 1));
    if (ardupilotReady) {
      return false;
    }
    return true;
  });

  // Ask the device to stream data to us
  requestDataStreamAll();

  // Set the mode to Guided
  setModeGuided();

  // Wait here while the device does it's prearm checks
  await Future.doWhile(() async {
    await Future.delayed(Duration(seconds: 1));
    // For Ardupilot, we can monitor the SysStatus message and look at the prearm check bitfield to determine when it's ready to be armed
    if (((lastSysStatus?.onboardControlSensorsHealth ?? 0) & mavSysStatusPrearmCheck) > 0) {
      print("prearm checks passed, ready to arm");
      return false;
    }
    return true;
  });

  // arm the device
  sendArmCommand();
  // Send a takeoff command
  sendTakeoffCommand();

  // Wait 30 seconds and then put it in land mode.
  await Future.delayed(Duration(seconds: 30));
  setModeRTL();
}

void requestDataStreamAll() {
  var msg = RequestDataStream(reqMessageRate: 1, targetSystem: 1, targetComponent: 1, reqStreamId: mavDataStreamAll, startStop: 1);
  sendMessage(msg);
}

void setModeGuided() {
  print("Setting mode to guided");
  var command = CommandLong(
      command: mavCmdDoSetMode,
      param1: 1,
      param2: 4,
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

void setModeRTL() {
  print("Setting mode to RTL");
  var command = CommandLong(
      command: mavCmdDoSetMode,
      param1: 1,
      param2: 6,
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

void sendHeartbeat() {
  Heartbeat heartbeat =
      Heartbeat(type: mavTypeGeneric, autopilot: mavAutopilotGeneric, baseMode: 0, customMode: 0, systemStatus: mavStateActive, mavlinkVersion: 2);
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

void sendTakeoffCommand() {
  print("Sending takeoff command");
  var command = CommandLong(
      command: mavCmdNavTakeoff,
      param1: 0,
      param2: 0,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 30,
      targetSystem: 1,
      targetComponent: 1,
      confirmation: 0);
  sendMessage(command);
}

void handleHeartbeat(Heartbeat msg) {
  lastHeartbeat = msg;
  print("Heartbeat: BaseMode: ${msg.baseMode} State: ${msg.systemStatus} CustomMode: ${msg.customMode}");
}

void handleStatusText(Statustext msg) {
  String decoded = convertMavlinkCharListToString(msg.text);
  print("Status Text: $decoded");
  if (!ardupilotReady && decoded == "ArduPilot Ready") {
    ardupilotReady = true;
  }
}

void handleBatteryStatus(BatteryStatus msg){

}

void handleCommandAck(CommandAck msg) {
  print("Command ack: Command ${msg.command} Result: ${msg.result}");
}

void sendMessage(MavlinkMessage msg) {
  var frame = MavlinkFrame.v2(sequence, mySystemId, myComponentId, msg);
  sitlSocket?.add(frame.serialize());
  sequence = (sequence == 255) ? 0 : sequence + 1;
}

String convertMavlinkCharListToString(List<int>? charList) {
  if (charList == null) {
    return "";
  }
  List<int> trimmedName = [];
  for (int character in charList) {
    if (character != 0x00 && character > 0) {
      trimmedName.add(character);
    }
  }
  return ascii.decode(trimmedName);
}

void printSystemState() {
  var agl = (lastGlobalPositionInt?.relativeAlt ?? 0) / 1000;
  var msl = (lastGlobalPositionInt?.alt ?? 0) / 1000;
  print("Alt AGL: ${agl.toStringAsFixed(1)} m \t Alt MSL: ${msl.toStringAsFixed(1)} m");
}
