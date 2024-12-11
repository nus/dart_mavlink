# dart_mavlink

This is a Dart package which parse and serialize MAVLink v1/v2 packets.

## Basic Usage

Import the library with 
```dart
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
```

### Parsing Messages

Each dialect.xml will have a corresponding class in the library. Select which one you want to use, and pass that dialect to a MavlinkParser object. 
```dart
var parser = MavlinkParser(MavlinkDialectCommon()); // Create the parser with the MavlinkCommon dialect
```

The ```MavlinkParser``` has a Stream that emits ```MavlinkFrame``` objects when it successfully decodes one from parsed data. Inside of the MavlinkFrame is the actual ```MavlinkMessage``` object which we can feed into a switch statement to do things based on when we receive specific kinds of messages. For more detail on structure of mavlink frames/messages see https://mavlink.io/en/guide/serialization.html

```dart
  parser.stream.listen((MavlinkFrame frame) {
    MavlinkMessage message = frame.message;
    var messageType = frame.message.runtimeType;
    switch (messageType) {
      case Heartbeat:
        doSomethingWithHeartbeat(message as Heartbeat);
        break;
      case Statustext:
        doSomethingWithStatusText(message as Statustext);
      case BatteryStatus:
        doSomethingWithBatteryStatus(message as BatteryStatus)
        break;
      default:
        break;
    }
  });

  void doSomethingWithBatteryStatus(BatteryStatus msg){
    print("Got a BatteryStatus message! Charge State: ${msg.chargeState}");
  }
```

We can now feed data into the parse. It can come from anywhere, typically a TCP socket. In this example, just using a byte list.

```dart
var sampleBatteryStatus = Uint8List.fromList([
    0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xd2, 0x0f, 0xd2, 0x0f, 0xd2, 0x0f,
    0xd2, 0x0f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9c, 0xff,
    0x00, 0x01, 0x01, 0x64, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff
]);

parser.parse(sampleBatteryStatus);
```

This will cause the ```doSomethingWithBatteryStatus``` function to execute.

### Serializing Messages

TODO

## Example Control of Simulated Ardupilot Copter
An example script has been provided that sends/receives commands from a simulated Ardupilot quadcopter. The specific details of using/flying an Ardupilot vehicle are beyond the scope of this library, but their conveniently pre-compiled Software-in-the-Loop (SITL) binaries are a convenient way to show how the libary might be used to command one.

Download the Ardupilot SITL binary and a default parameter file from the Ardupilot github, give it executable permission, then run it. This is assuming x86-64 Linux, but it should work the same in WSL
```
mkdir example/ardupilot_sitl && cd example/ardupilot_sitl
wget https://firmware.ardupilot.org/Copter/stable-4.5.7/SITL_x86_64_linux_gnu/arducopter
wget https://raw.githubusercontent.com/ArduPilot/ardupilot/42ad2a7911f1239e9320ca9ba67877d09840545f/Tools/autotest/default_params/copter.parm
chmod +x arducopter
./arducopter --defaults ./copter.parm --model + --sim-address 127.0.0.1
```

In another window, or in your IDE, run the `sitl_test.dart` example in the examples folder
```
dart ./example/sitl_test.dart
```

You will see the following sequence in the output of the sitl_test script:
- Wait for vehicle to boot by monitoring for a STATUSTEXT mavlink message
- Change the mode from STABILIZE to GUIDED
- Wait for pre-arm checks to pass (will take 30-60 seconds)
- Arm the vehicle
- Command vehicle to takeoff ot 30 meters
- Wait 30 seconds
- Command the vehicle to Return To Land (RTL)

See the comments in the script for more detail on usage.