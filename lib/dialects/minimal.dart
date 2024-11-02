import 'dart:typed_data';
import 'package:dart_mavlink/mavlink_dialect.dart';
import 'package:dart_mavlink/mavlink_message.dart';
import 'package:dart_mavlink/types.dart';

/// Micro air vehicle / autopilot classes. This identifies the individual model.
///
/// MAV_AUTOPILOT
typedef MavAutopilot = int;

/// Generic autopilot, full support for everything
///
/// MAV_AUTOPILOT_GENERIC
const MavAutopilot mavAutopilotGeneric = 0;

/// Reserved for future use.
///
/// MAV_AUTOPILOT_RESERVED
const MavAutopilot mavAutopilotReserved = 1;

/// SLUGS autopilot, http://slugsuav.soe.ucsc.edu
///
/// MAV_AUTOPILOT_SLUGS
const MavAutopilot mavAutopilotSlugs = 2;

/// ArduPilot - Plane/Copter/Rover/Sub/Tracker, https://ardupilot.org
///
/// MAV_AUTOPILOT_ARDUPILOTMEGA
const MavAutopilot mavAutopilotArdupilotmega = 3;

/// OpenPilot, http://openpilot.org
///
/// MAV_AUTOPILOT_OPENPILOT
const MavAutopilot mavAutopilotOpenpilot = 4;

/// Generic autopilot only supporting simple waypoints
///
/// MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY
const MavAutopilot mavAutopilotGenericWaypointsOnly = 5;

/// Generic autopilot supporting waypoints and other simple navigation commands
///
/// MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY
const MavAutopilot mavAutopilotGenericWaypointsAndSimpleNavigationOnly = 6;

/// Generic autopilot supporting the full mission command set
///
/// MAV_AUTOPILOT_GENERIC_MISSION_FULL
const MavAutopilot mavAutopilotGenericMissionFull = 7;

/// No valid autopilot, e.g. a GCS or other MAVLink component
///
/// MAV_AUTOPILOT_INVALID
const MavAutopilot mavAutopilotInvalid = 8;

/// PPZ UAV - http://nongnu.org/paparazzi
///
/// MAV_AUTOPILOT_PPZ
const MavAutopilot mavAutopilotPpz = 9;

/// UAV Dev Board
///
/// MAV_AUTOPILOT_UDB
const MavAutopilot mavAutopilotUdb = 10;

/// FlexiPilot
///
/// MAV_AUTOPILOT_FP
const MavAutopilot mavAutopilotFp = 11;

/// PX4 Autopilot - http://px4.io/
///
/// MAV_AUTOPILOT_PX4
const MavAutopilot mavAutopilotPx4 = 12;

/// SMACCMPilot - http://smaccmpilot.org
///
/// MAV_AUTOPILOT_SMACCMPILOT
const MavAutopilot mavAutopilotSmaccmpilot = 13;

/// AutoQuad -- http://autoquad.org
///
/// MAV_AUTOPILOT_AUTOQUAD
const MavAutopilot mavAutopilotAutoquad = 14;

/// Armazila -- http://armazila.com
///
/// MAV_AUTOPILOT_ARMAZILA
const MavAutopilot mavAutopilotArmazila = 15;

/// Aerob -- http://aerob.ru
///
/// MAV_AUTOPILOT_AEROB
const MavAutopilot mavAutopilotAerob = 16;

/// ASLUAV autopilot -- http://www.asl.ethz.ch
///
/// MAV_AUTOPILOT_ASLUAV
const MavAutopilot mavAutopilotAsluav = 17;

/// SmartAP Autopilot - http://sky-drones.com
///
/// MAV_AUTOPILOT_SMARTAP
const MavAutopilot mavAutopilotSmartap = 18;

/// AirRails - http://uaventure.com
///
/// MAV_AUTOPILOT_AIRRAILS
const MavAutopilot mavAutopilotAirrails = 19;

/// Fusion Reflex - https://fusion.engineering
///
/// MAV_AUTOPILOT_REFLEX
const MavAutopilot mavAutopilotReflex = 20;

/// MAVLINK component type reported in HEARTBEAT message. Flight controllers must report the type of the vehicle on which they are mounted (e.g. MAV_TYPE_OCTOROTOR). All other components must report a value appropriate for their type (e.g. a camera must use MAV_TYPE_CAMERA).
///
/// MAV_TYPE
typedef MavType = int;

/// Generic micro air vehicle
///
/// MAV_TYPE_GENERIC
const MavType mavTypeGeneric = 0;

/// Fixed wing aircraft.
///
/// MAV_TYPE_FIXED_WING
const MavType mavTypeFixedWing = 1;

/// Quadrotor
///
/// MAV_TYPE_QUADROTOR
const MavType mavTypeQuadrotor = 2;

/// Coaxial helicopter
///
/// MAV_TYPE_COAXIAL
const MavType mavTypeCoaxial = 3;

/// Normal helicopter with tail rotor.
///
/// MAV_TYPE_HELICOPTER
const MavType mavTypeHelicopter = 4;

/// Ground installation
///
/// MAV_TYPE_ANTENNA_TRACKER
const MavType mavTypeAntennaTracker = 5;

/// Operator control unit / ground control station
///
/// MAV_TYPE_GCS
const MavType mavTypeGcs = 6;

/// Airship, controlled
///
/// MAV_TYPE_AIRSHIP
const MavType mavTypeAirship = 7;

/// Free balloon, uncontrolled
///
/// MAV_TYPE_FREE_BALLOON
const MavType mavTypeFreeBalloon = 8;

/// Rocket
///
/// MAV_TYPE_ROCKET
const MavType mavTypeRocket = 9;

/// Ground rover
///
/// MAV_TYPE_GROUND_ROVER
const MavType mavTypeGroundRover = 10;

/// Surface vessel, boat, ship
///
/// MAV_TYPE_SURFACE_BOAT
const MavType mavTypeSurfaceBoat = 11;

/// Submarine
///
/// MAV_TYPE_SUBMARINE
const MavType mavTypeSubmarine = 12;

/// Hexarotor
///
/// MAV_TYPE_HEXAROTOR
const MavType mavTypeHexarotor = 13;

/// Octorotor
///
/// MAV_TYPE_OCTOROTOR
const MavType mavTypeOctorotor = 14;

/// Tricopter
///
/// MAV_TYPE_TRICOPTER
const MavType mavTypeTricopter = 15;

/// Flapping wing
///
/// MAV_TYPE_FLAPPING_WING
const MavType mavTypeFlappingWing = 16;

/// Kite
///
/// MAV_TYPE_KITE
const MavType mavTypeKite = 17;

/// Onboard companion controller
///
/// MAV_TYPE_ONBOARD_CONTROLLER
const MavType mavTypeOnboardController = 18;

/// Two-rotor Tailsitter VTOL that additionally uses control surfaces in vertical operation. Note, value previously named MAV_TYPE_VTOL_DUOROTOR.
///
/// MAV_TYPE_VTOL_TAILSITTER_DUOROTOR
const MavType mavTypeVtolTailsitterDuorotor = 19;

/// Quad-rotor Tailsitter VTOL using a V-shaped quad config in vertical operation. Note: value previously named MAV_TYPE_VTOL_QUADROTOR.
///
/// MAV_TYPE_VTOL_TAILSITTER_QUADROTOR
const MavType mavTypeVtolTailsitterQuadrotor = 20;

/// Tiltrotor VTOL. Fuselage and wings stay (nominally) horizontal in all flight phases. It able to tilt (some) rotors to provide thrust in cruise flight.
///
/// MAV_TYPE_VTOL_TILTROTOR
const MavType mavTypeVtolTiltrotor = 21;

/// VTOL with separate fixed rotors for hover and cruise flight. Fuselage and wings stay (nominally) horizontal in all flight phases.
///
/// MAV_TYPE_VTOL_FIXEDROTOR
const MavType mavTypeVtolFixedrotor = 22;

/// Tailsitter VTOL. Fuselage and wings orientation changes depending on flight phase: vertical for hover, horizontal for cruise. Use more specific VTOL MAV_TYPE_VTOL_TAILSITTER_DUOROTOR or MAV_TYPE_VTOL_TAILSITTER_QUADROTOR if appropriate.
///
/// MAV_TYPE_VTOL_TAILSITTER
const MavType mavTypeVtolTailsitter = 23;

/// Tiltwing VTOL. Fuselage stays horizontal in all flight phases. The whole wing, along with any attached engine, can tilt between vertical and horizontal mode.
///
/// MAV_TYPE_VTOL_TILTWING
const MavType mavTypeVtolTiltwing = 24;

/// VTOL reserved 5
///
/// MAV_TYPE_VTOL_RESERVED5
const MavType mavTypeVtolReserved5 = 25;

/// Gimbal
///
/// MAV_TYPE_GIMBAL
const MavType mavTypeGimbal = 26;

/// ADSB system
///
/// MAV_TYPE_ADSB
const MavType mavTypeAdsb = 27;

/// Steerable, nonrigid airfoil
///
/// MAV_TYPE_PARAFOIL
const MavType mavTypeParafoil = 28;

/// Dodecarotor
///
/// MAV_TYPE_DODECAROTOR
const MavType mavTypeDodecarotor = 29;

/// Camera
///
/// MAV_TYPE_CAMERA
const MavType mavTypeCamera = 30;

/// Charging station
///
/// MAV_TYPE_CHARGING_STATION
const MavType mavTypeChargingStation = 31;

/// FLARM collision avoidance system
///
/// MAV_TYPE_FLARM
const MavType mavTypeFlarm = 32;

/// Servo
///
/// MAV_TYPE_SERVO
const MavType mavTypeServo = 33;

/// Open Drone ID. See https://mavlink.io/en/services/opendroneid.html.
///
/// MAV_TYPE_ODID
const MavType mavTypeOdid = 34;

/// Decarotor
///
/// MAV_TYPE_DECAROTOR
const MavType mavTypeDecarotor = 35;

/// Battery
///
/// MAV_TYPE_BATTERY
const MavType mavTypeBattery = 36;

/// Parachute
///
/// MAV_TYPE_PARACHUTE
const MavType mavTypeParachute = 37;

/// Log
///
/// MAV_TYPE_LOG
const MavType mavTypeLog = 38;

/// OSD
///
/// MAV_TYPE_OSD
const MavType mavTypeOsd = 39;

/// IMU
///
/// MAV_TYPE_IMU
const MavType mavTypeImu = 40;

/// GPS
///
/// MAV_TYPE_GPS
const MavType mavTypeGps = 41;

/// Winch
///
/// MAV_TYPE_WINCH
const MavType mavTypeWinch = 42;

/// Generic multirotor that does not fit into a specific type or whose type is unknown
///
/// MAV_TYPE_GENERIC_MULTIROTOR
const MavType mavTypeGenericMultirotor = 43;

/// These flags encode the MAV mode.
///
/// MAV_MODE_FLAG
typedef MavModeFlag = int;

/// 0b10000000 MAV safety set to armed. Motors are enabled / running / can start. Ready to fly. Additional note: this flag is to be ignore when sent in the command MAV_CMD_DO_SET_MODE and MAV_CMD_COMPONENT_ARM_DISARM shall be used instead. The flag can still be used to report the armed state.
///
/// MAV_MODE_FLAG_SAFETY_ARMED
const MavModeFlag mavModeFlagSafetyArmed = 128;

/// 0b01000000 remote control input is enabled.
///
/// MAV_MODE_FLAG_MANUAL_INPUT_ENABLED
const MavModeFlag mavModeFlagManualInputEnabled = 64;

/// 0b00100000 hardware in the loop simulation. All motors / actuators are blocked, but internal software is full operational.
///
/// MAV_MODE_FLAG_HIL_ENABLED
const MavModeFlag mavModeFlagHilEnabled = 32;

/// 0b00010000 system stabilizes electronically its attitude (and optionally position). It needs however further control inputs to move around.
///
/// MAV_MODE_FLAG_STABILIZE_ENABLED
const MavModeFlag mavModeFlagStabilizeEnabled = 16;

/// 0b00001000 guided mode enabled, system flies waypoints / mission items.
///
/// MAV_MODE_FLAG_GUIDED_ENABLED
const MavModeFlag mavModeFlagGuidedEnabled = 8;

/// 0b00000100 autonomous mode enabled, system finds its own goal positions. Guided flag can be set or not, depends on the actual implementation.
///
/// MAV_MODE_FLAG_AUTO_ENABLED
const MavModeFlag mavModeFlagAutoEnabled = 4;

/// 0b00000010 system has a test mode enabled. This flag is intended for temporary system tests and should not be used for stable implementations.
///
/// MAV_MODE_FLAG_TEST_ENABLED
const MavModeFlag mavModeFlagTestEnabled = 2;

/// 0b00000001 Reserved for future use.
///
/// MAV_MODE_FLAG_CUSTOM_MODE_ENABLED
const MavModeFlag mavModeFlagCustomModeEnabled = 1;

/// These values encode the bit positions of the decode position. These values can be used to read the value of a flag bit by combining the base_mode variable with AND with the flag position value. The result will be either 0 or 1, depending on if the flag is set or not.
///
/// MAV_MODE_FLAG_DECODE_POSITION
typedef MavModeFlagDecodePosition = int;

/// First bit:  10000000
///
/// MAV_MODE_FLAG_DECODE_POSITION_SAFETY
const MavModeFlagDecodePosition mavModeFlagDecodePositionSafety = 128;

/// Second bit: 01000000
///
/// MAV_MODE_FLAG_DECODE_POSITION_MANUAL
const MavModeFlagDecodePosition mavModeFlagDecodePositionManual = 64;

/// Third bit:  00100000
///
/// MAV_MODE_FLAG_DECODE_POSITION_HIL
const MavModeFlagDecodePosition mavModeFlagDecodePositionHil = 32;

/// Fourth bit: 00010000
///
/// MAV_MODE_FLAG_DECODE_POSITION_STABILIZE
const MavModeFlagDecodePosition mavModeFlagDecodePositionStabilize = 16;

/// Fifth bit:  00001000
///
/// MAV_MODE_FLAG_DECODE_POSITION_GUIDED
const MavModeFlagDecodePosition mavModeFlagDecodePositionGuided = 8;

/// Sixth bit:   00000100
///
/// MAV_MODE_FLAG_DECODE_POSITION_AUTO
const MavModeFlagDecodePosition mavModeFlagDecodePositionAuto = 4;

/// Seventh bit: 00000010
///
/// MAV_MODE_FLAG_DECODE_POSITION_TEST
const MavModeFlagDecodePosition mavModeFlagDecodePositionTest = 2;

/// Eighth bit: 00000001
///
/// MAV_MODE_FLAG_DECODE_POSITION_CUSTOM_MODE
const MavModeFlagDecodePosition mavModeFlagDecodePositionCustomMode = 1;

///
/// MAV_STATE
typedef MavState = int;

/// Uninitialized system, state is unknown.
///
/// MAV_STATE_UNINIT
const MavState mavStateUninit = 0;

/// System is booting up.
///
/// MAV_STATE_BOOT
const MavState mavStateBoot = 1;

/// System is calibrating and not flight-ready.
///
/// MAV_STATE_CALIBRATING
const MavState mavStateCalibrating = 2;

/// System is grounded and on standby. It can be launched any time.
///
/// MAV_STATE_STANDBY
const MavState mavStateStandby = 3;

/// System is active and might be already airborne. Motors are engaged.
///
/// MAV_STATE_ACTIVE
const MavState mavStateActive = 4;

/// System is in a non-normal flight mode (failsafe). It can however still navigate.
///
/// MAV_STATE_CRITICAL
const MavState mavStateCritical = 5;

/// System is in a non-normal flight mode (failsafe). It lost control over parts or over the whole airframe. It is in mayday and going down.
///
/// MAV_STATE_EMERGENCY
const MavState mavStateEmergency = 6;

/// System just initialized its power-down sequence, will shut down now.
///
/// MAV_STATE_POWEROFF
const MavState mavStatePoweroff = 7;

/// System is terminating itself (failsafe or commanded).
///
/// MAV_STATE_FLIGHT_TERMINATION
const MavState mavStateFlightTermination = 8;

/// Component ids (values) for the different types and instances of onboard hardware/software that might make up a MAVLink system (autopilot, cameras, servos, GPS systems, avoidance systems etc.).
/// Components must use the appropriate ID in their source address when sending messages. Components can also use IDs to determine if they are the intended recipient of an incoming message. The MAV_COMP_ID_ALL value is used to indicate messages that must be processed by all components.
/// When creating new entries, components that can have multiple instances (e.g. cameras, servos etc.) should be allocated sequential values. An appropriate number of values should be left free after these components to allow the number of instances to be expanded.
///
/// MAV_COMPONENT
typedef MavComponent = int;

/// Target id (target_component) used to broadcast messages to all components of the receiving system. Components should attempt to process messages with this component ID and forward to components on any other interfaces. Note: This is not a valid *source* component id for a message.
///
/// MAV_COMP_ID_ALL
const MavComponent mavCompIdAll = 0;

/// System flight controller component ("autopilot"). Only one autopilot is expected in a particular system.
///
/// MAV_COMP_ID_AUTOPILOT1
const MavComponent mavCompIdAutopilot1 = 1;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER1
const MavComponent mavCompIdUser1 = 25;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER2
const MavComponent mavCompIdUser2 = 26;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER3
const MavComponent mavCompIdUser3 = 27;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER4
const MavComponent mavCompIdUser4 = 28;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER5
const MavComponent mavCompIdUser5 = 29;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER6
const MavComponent mavCompIdUser6 = 30;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER7
const MavComponent mavCompIdUser7 = 31;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER8
const MavComponent mavCompIdUser8 = 32;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER9
const MavComponent mavCompIdUser9 = 33;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER10
const MavComponent mavCompIdUser10 = 34;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER11
const MavComponent mavCompIdUser11 = 35;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER12
const MavComponent mavCompIdUser12 = 36;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER13
const MavComponent mavCompIdUser13 = 37;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER14
const MavComponent mavCompIdUser14 = 38;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER15
const MavComponent mavCompIdUser15 = 39;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER16
const MavComponent mavCompIdUser16 = 40;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER17
const MavComponent mavCompIdUser17 = 41;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER18
const MavComponent mavCompIdUser18 = 42;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER19
const MavComponent mavCompIdUser19 = 43;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER20
const MavComponent mavCompIdUser20 = 44;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER21
const MavComponent mavCompIdUser21 = 45;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER22
const MavComponent mavCompIdUser22 = 46;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER23
const MavComponent mavCompIdUser23 = 47;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER24
const MavComponent mavCompIdUser24 = 48;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER25
const MavComponent mavCompIdUser25 = 49;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER26
const MavComponent mavCompIdUser26 = 50;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER27
const MavComponent mavCompIdUser27 = 51;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER28
const MavComponent mavCompIdUser28 = 52;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER29
const MavComponent mavCompIdUser29 = 53;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER30
const MavComponent mavCompIdUser30 = 54;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER31
const MavComponent mavCompIdUser31 = 55;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER32
const MavComponent mavCompIdUser32 = 56;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER33
const MavComponent mavCompIdUser33 = 57;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER34
const MavComponent mavCompIdUser34 = 58;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER35
const MavComponent mavCompIdUser35 = 59;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER36
const MavComponent mavCompIdUser36 = 60;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER37
const MavComponent mavCompIdUser37 = 61;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER38
const MavComponent mavCompIdUser38 = 62;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER39
const MavComponent mavCompIdUser39 = 63;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER40
const MavComponent mavCompIdUser40 = 64;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER41
const MavComponent mavCompIdUser41 = 65;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER42
const MavComponent mavCompIdUser42 = 66;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER43
const MavComponent mavCompIdUser43 = 67;

/// Telemetry radio (e.g. SiK radio, or other component that emits RADIO_STATUS messages).
///
/// MAV_COMP_ID_TELEMETRY_RADIO
const MavComponent mavCompIdTelemetryRadio = 68;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER45
const MavComponent mavCompIdUser45 = 69;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER46
const MavComponent mavCompIdUser46 = 70;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER47
const MavComponent mavCompIdUser47 = 71;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER48
const MavComponent mavCompIdUser48 = 72;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER49
const MavComponent mavCompIdUser49 = 73;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER50
const MavComponent mavCompIdUser50 = 74;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER51
const MavComponent mavCompIdUser51 = 75;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER52
const MavComponent mavCompIdUser52 = 76;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER53
const MavComponent mavCompIdUser53 = 77;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER54
const MavComponent mavCompIdUser54 = 78;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER55
const MavComponent mavCompIdUser55 = 79;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER56
const MavComponent mavCompIdUser56 = 80;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER57
const MavComponent mavCompIdUser57 = 81;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER58
const MavComponent mavCompIdUser58 = 82;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER59
const MavComponent mavCompIdUser59 = 83;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER60
const MavComponent mavCompIdUser60 = 84;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER61
const MavComponent mavCompIdUser61 = 85;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER62
const MavComponent mavCompIdUser62 = 86;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER63
const MavComponent mavCompIdUser63 = 87;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER64
const MavComponent mavCompIdUser64 = 88;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER65
const MavComponent mavCompIdUser65 = 89;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER66
const MavComponent mavCompIdUser66 = 90;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER67
const MavComponent mavCompIdUser67 = 91;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER68
const MavComponent mavCompIdUser68 = 92;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER69
const MavComponent mavCompIdUser69 = 93;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER70
const MavComponent mavCompIdUser70 = 94;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER71
const MavComponent mavCompIdUser71 = 95;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER72
const MavComponent mavCompIdUser72 = 96;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER73
const MavComponent mavCompIdUser73 = 97;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER74
const MavComponent mavCompIdUser74 = 98;

/// Id for a component on privately managed MAVLink network. Can be used for any purpose but may not be published by components outside of the private network.
///
/// MAV_COMP_ID_USER75
const MavComponent mavCompIdUser75 = 99;

/// Camera #1.
///
/// MAV_COMP_ID_CAMERA
const MavComponent mavCompIdCamera = 100;

/// Camera #2.
///
/// MAV_COMP_ID_CAMERA2
const MavComponent mavCompIdCamera2 = 101;

/// Camera #3.
///
/// MAV_COMP_ID_CAMERA3
const MavComponent mavCompIdCamera3 = 102;

/// Camera #4.
///
/// MAV_COMP_ID_CAMERA4
const MavComponent mavCompIdCamera4 = 103;

/// Camera #5.
///
/// MAV_COMP_ID_CAMERA5
const MavComponent mavCompIdCamera5 = 104;

/// Camera #6.
///
/// MAV_COMP_ID_CAMERA6
const MavComponent mavCompIdCamera6 = 105;

/// Servo #1.
///
/// MAV_COMP_ID_SERVO1
const MavComponent mavCompIdServo1 = 140;

/// Servo #2.
///
/// MAV_COMP_ID_SERVO2
const MavComponent mavCompIdServo2 = 141;

/// Servo #3.
///
/// MAV_COMP_ID_SERVO3
const MavComponent mavCompIdServo3 = 142;

/// Servo #4.
///
/// MAV_COMP_ID_SERVO4
const MavComponent mavCompIdServo4 = 143;

/// Servo #5.
///
/// MAV_COMP_ID_SERVO5
const MavComponent mavCompIdServo5 = 144;

/// Servo #6.
///
/// MAV_COMP_ID_SERVO6
const MavComponent mavCompIdServo6 = 145;

/// Servo #7.
///
/// MAV_COMP_ID_SERVO7
const MavComponent mavCompIdServo7 = 146;

/// Servo #8.
///
/// MAV_COMP_ID_SERVO8
const MavComponent mavCompIdServo8 = 147;

/// Servo #9.
///
/// MAV_COMP_ID_SERVO9
const MavComponent mavCompIdServo9 = 148;

/// Servo #10.
///
/// MAV_COMP_ID_SERVO10
const MavComponent mavCompIdServo10 = 149;

/// Servo #11.
///
/// MAV_COMP_ID_SERVO11
const MavComponent mavCompIdServo11 = 150;

/// Servo #12.
///
/// MAV_COMP_ID_SERVO12
const MavComponent mavCompIdServo12 = 151;

/// Servo #13.
///
/// MAV_COMP_ID_SERVO13
const MavComponent mavCompIdServo13 = 152;

/// Servo #14.
///
/// MAV_COMP_ID_SERVO14
const MavComponent mavCompIdServo14 = 153;

/// Gimbal #1.
///
/// MAV_COMP_ID_GIMBAL
const MavComponent mavCompIdGimbal = 154;

/// Logging component.
///
/// MAV_COMP_ID_LOG
const MavComponent mavCompIdLog = 155;

/// Automatic Dependent Surveillance-Broadcast (ADS-B) component.
///
/// MAV_COMP_ID_ADSB
const MavComponent mavCompIdAdsb = 156;

/// On Screen Display (OSD) devices for video links.
///
/// MAV_COMP_ID_OSD
const MavComponent mavCompIdOsd = 157;

/// Generic autopilot peripheral component ID. Meant for devices that do not implement the parameter microservice.
///
/// MAV_COMP_ID_PERIPHERAL
const MavComponent mavCompIdPeripheral = 158;

/// Gimbal ID for QX1.
///
/// MAV_COMP_ID_QX1_GIMBAL
@Deprecated(
    "Replaced by [MAV_COMP_ID_GIMBAL] since 2018-11. All gimbals should use MAV_COMP_ID_GIMBAL.")
const MavComponent mavCompIdQx1Gimbal = 159;

/// FLARM collision alert component.
///
/// MAV_COMP_ID_FLARM
const MavComponent mavCompIdFlarm = 160;

/// Parachute component.
///
/// MAV_COMP_ID_PARACHUTE
const MavComponent mavCompIdParachute = 161;

/// Winch component.
///
/// MAV_COMP_ID_WINCH
const MavComponent mavCompIdWinch = 169;

/// Gimbal #2.
///
/// MAV_COMP_ID_GIMBAL2
const MavComponent mavCompIdGimbal2 = 171;

/// Gimbal #3.
///
/// MAV_COMP_ID_GIMBAL3
const MavComponent mavCompIdGimbal3 = 172;

/// Gimbal #4
///
/// MAV_COMP_ID_GIMBAL4
const MavComponent mavCompIdGimbal4 = 173;

/// Gimbal #5.
///
/// MAV_COMP_ID_GIMBAL5
const MavComponent mavCompIdGimbal5 = 174;

/// Gimbal #6.
///
/// MAV_COMP_ID_GIMBAL6
const MavComponent mavCompIdGimbal6 = 175;

/// Battery #1.
///
/// MAV_COMP_ID_BATTERY
const MavComponent mavCompIdBattery = 180;

/// Battery #2.
///
/// MAV_COMP_ID_BATTERY2
const MavComponent mavCompIdBattery2 = 181;

/// CAN over MAVLink client.
///
/// MAV_COMP_ID_MAVCAN
const MavComponent mavCompIdMavcan = 189;

/// Component that can generate/supply a mission flight plan (e.g. GCS or developer API).
///
/// MAV_COMP_ID_MISSIONPLANNER
const MavComponent mavCompIdMissionplanner = 190;

/// Component that lives on the onboard computer (companion computer) and has some generic functionalities, such as settings system parameters and monitoring the status of some processes that don't directly speak mavlink and so on.
///
/// MAV_COMP_ID_ONBOARD_COMPUTER
const MavComponent mavCompIdOnboardComputer = 191;

/// Component that lives on the onboard computer (companion computer) and has some generic functionalities, such as settings system parameters and monitoring the status of some processes that don't directly speak mavlink and so on.
///
/// MAV_COMP_ID_ONBOARD_COMPUTER2
const MavComponent mavCompIdOnboardComputer2 = 192;

/// Component that lives on the onboard computer (companion computer) and has some generic functionalities, such as settings system parameters and monitoring the status of some processes that don't directly speak mavlink and so on.
///
/// MAV_COMP_ID_ONBOARD_COMPUTER3
const MavComponent mavCompIdOnboardComputer3 = 193;

/// Component that lives on the onboard computer (companion computer) and has some generic functionalities, such as settings system parameters and monitoring the status of some processes that don't directly speak mavlink and so on.
///
/// MAV_COMP_ID_ONBOARD_COMPUTER4
const MavComponent mavCompIdOnboardComputer4 = 194;

/// Component that finds an optimal path between points based on a certain constraint (e.g. minimum snap, shortest path, cost, etc.).
///
/// MAV_COMP_ID_PATHPLANNER
const MavComponent mavCompIdPathplanner = 195;

/// Component that plans a collision free path between two points.
///
/// MAV_COMP_ID_OBSTACLE_AVOIDANCE
const MavComponent mavCompIdObstacleAvoidance = 196;

/// Component that provides position estimates using VIO techniques.
///
/// MAV_COMP_ID_VISUAL_INERTIAL_ODOMETRY
const MavComponent mavCompIdVisualInertialOdometry = 197;

/// Component that manages pairing of vehicle and GCS.
///
/// MAV_COMP_ID_PAIRING_MANAGER
const MavComponent mavCompIdPairingManager = 198;

/// Inertial Measurement Unit (IMU) #1.
///
/// MAV_COMP_ID_IMU
const MavComponent mavCompIdImu = 200;

/// Inertial Measurement Unit (IMU) #2.
///
/// MAV_COMP_ID_IMU_2
const MavComponent mavCompIdImu2 = 201;

/// Inertial Measurement Unit (IMU) #3.
///
/// MAV_COMP_ID_IMU_3
const MavComponent mavCompIdImu3 = 202;

/// GPS #1.
///
/// MAV_COMP_ID_GPS
const MavComponent mavCompIdGps = 220;

/// GPS #2.
///
/// MAV_COMP_ID_GPS2
const MavComponent mavCompIdGps2 = 221;

/// Open Drone ID transmitter/receiver (Bluetooth/WiFi/Internet).
///
/// MAV_COMP_ID_ODID_TXRX_1
const MavComponent mavCompIdOdidTxrx1 = 236;

/// Open Drone ID transmitter/receiver (Bluetooth/WiFi/Internet).
///
/// MAV_COMP_ID_ODID_TXRX_2
const MavComponent mavCompIdOdidTxrx2 = 237;

/// Open Drone ID transmitter/receiver (Bluetooth/WiFi/Internet).
///
/// MAV_COMP_ID_ODID_TXRX_3
const MavComponent mavCompIdOdidTxrx3 = 238;

/// Component to bridge MAVLink to UDP (i.e. from a UART).
///
/// MAV_COMP_ID_UDP_BRIDGE
const MavComponent mavCompIdUdpBridge = 240;

/// Component to bridge to UART (i.e. from UDP).
///
/// MAV_COMP_ID_UART_BRIDGE
const MavComponent mavCompIdUartBridge = 241;

/// Component handling TUNNEL messages (e.g. vendor specific GUI of a component).
///
/// MAV_COMP_ID_TUNNEL_NODE
const MavComponent mavCompIdTunnelNode = 242;

/// Deprecated, don't use. Component for handling system messages (e.g. to ARM, takeoff, etc.).
///
/// MAV_COMP_ID_SYSTEM_CONTROL
@Deprecated(
    "Replaced by [MAV_COMP_ID_ALL] since 2018-11. System control does not require a separate component ID. Instead, system commands should be sent with target_component=MAV_COMP_ID_ALL allowing the target component to use any appropriate component id.")
const MavComponent mavCompIdSystemControl = 250;

/// The heartbeat message shows that a system or component is present and responding. The type and autopilot fields (along with the message component id), allow the receiving system to treat further messages from this system appropriately (e.g. by laying out the user interface based on the autopilot). This microservice is documented at https://mavlink.io/en/services/heartbeat.html
///
/// HEARTBEAT
class Heartbeat implements MavlinkMessage {
  static const int _mavlinkMessageId = 0;

  static const int _mavlinkCrcExtra = 50;

  static const int mavlinkEncodedLength = 9;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// A bitfield for use for autopilot-specific flags
  ///
  /// MAVLink type: uint32_t
  ///
  /// custom_mode
  final uint32_t customMode;

  /// Vehicle or component type. For a flight controller component the vehicle type (quadrotor, helicopter, etc.). For other components the component type (e.g. camera, gimbal, etc.). This should be used in preference to component id for identifying the component type.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavType]
  ///
  /// type
  final MavType type;

  /// Autopilot type / class. Use MAV_AUTOPILOT_INVALID for components that are not flight controllers.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavAutopilot]
  ///
  /// autopilot
  final MavAutopilot autopilot;

  /// System mode bitmap.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavModeFlag]
  ///
  /// base_mode
  final MavModeFlag baseMode;

  /// System status flag.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavState]
  ///
  /// system_status
  final MavState systemStatus;

  /// MAVLink version, not writable by user, gets added by protocol because of magic data type: uint8_t_mavlink_version
  ///
  /// MAVLink type: uint8_t
  ///
  /// mavlink_version
  final uint8_t mavlinkVersion;

  Heartbeat({
    required this.customMode,
    required this.type,
    required this.autopilot,
    required this.baseMode,
    required this.systemStatus,
    required this.mavlinkVersion,
  });

  Heartbeat copyWith({
    int? customMode,
    int? type,
    int? autopilot,
    int? baseMode,
    int? systemStatus,
    int? mavlinkVersion,
  }) {
    return Heartbeat(
      customMode: customMode ?? this.customMode,
      type: type ?? this.type,
      autopilot: autopilot ?? this.autopilot,
      baseMode: baseMode ?? this.baseMode,
      systemStatus: systemStatus ?? this.systemStatus,
      mavlinkVersion: mavlinkVersion ?? this.mavlinkVersion,
    );
  }

  factory Heartbeat.parse(ByteData data_) {
    if (data_.lengthInBytes < Heartbeat.mavlinkEncodedLength) {
      var len = Heartbeat.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List() + List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var customMode = data_.getUint32(0, Endian.little);
    var type = data_.getUint8(4);
    var autopilot = data_.getUint8(5);
    var baseMode = data_.getUint8(6);
    var systemStatus = data_.getUint8(7);
    var mavlinkVersion = data_.getUint8(8);

    return Heartbeat(
        customMode: customMode,
        type: type,
        autopilot: autopilot,
        baseMode: baseMode,
        systemStatus: systemStatus,
        mavlinkVersion: mavlinkVersion);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, customMode, Endian.little);
    data_.setUint8(4, type);
    data_.setUint8(5, autopilot);
    data_.setUint8(6, baseMode);
    data_.setUint8(7, systemStatus);
    data_.setUint8(8, mavlinkVersion);
    return data_;
  }
}

/// Version and capability of protocol version. This message can be requested with MAV_CMD_REQUEST_MESSAGE and is used as part of the handshaking to establish which MAVLink version should be used on the network. Every node should respond to a request for PROTOCOL_VERSION to enable the handshaking. Library implementers should consider adding this into the default decoding state machine to allow the protocol core to respond directly.
///
/// PROTOCOL_VERSION
class ProtocolVersion implements MavlinkMessage {
  static const int _mavlinkMessageId = 300;

  static const int _mavlinkCrcExtra = 217;

  static const int mavlinkEncodedLength = 22;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Currently active MAVLink version number * 100: v1.0 is 100, v2.0 is 200, etc.
  ///
  /// MAVLink type: uint16_t
  ///
  /// version
  final uint16_t version;

  /// Minimum MAVLink version supported
  ///
  /// MAVLink type: uint16_t
  ///
  /// min_version
  final uint16_t minVersion;

  /// Maximum MAVLink version supported (set to the same value as version by default)
  ///
  /// MAVLink type: uint16_t
  ///
  /// max_version
  final uint16_t maxVersion;

  /// The first 8 bytes (not characters printed in hex!) of the git hash.
  ///
  /// MAVLink type: uint8_t[8]
  ///
  /// spec_version_hash
  final List<int8_t> specVersionHash;

  /// The first 8 bytes (not characters printed in hex!) of the git hash.
  ///
  /// MAVLink type: uint8_t[8]
  ///
  /// library_version_hash
  final List<int8_t> libraryVersionHash;

  ProtocolVersion({
    required this.version,
    required this.minVersion,
    required this.maxVersion,
    required this.specVersionHash,
    required this.libraryVersionHash,
  });

  ProtocolVersion copyWith({
    int? version,
    int? minVersion,
    int? maxVersion,
    List<int>? specVersionHash,
    List<int>? libraryVersionHash,
  }) {
    return ProtocolVersion(
      version: version ?? this.version,
      minVersion: minVersion ?? this.minVersion,
      maxVersion: maxVersion ?? this.maxVersion,
      specVersionHash: specVersionHash ?? this.specVersionHash,
      libraryVersionHash: libraryVersionHash ?? this.libraryVersionHash,
    );
  }

  factory ProtocolVersion.parse(ByteData data_) {
    if (data_.lengthInBytes < ProtocolVersion.mavlinkEncodedLength) {
      var len = ProtocolVersion.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List() + List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var version = data_.getUint16(0, Endian.little);
    var minVersion = data_.getUint16(2, Endian.little);
    var maxVersion = data_.getUint16(4, Endian.little);
    var specVersionHash = MavlinkMessage.asUint8List(data_, 6, 8);
    var libraryVersionHash = MavlinkMessage.asUint8List(data_, 14, 8);

    return ProtocolVersion(
        version: version,
        minVersion: minVersion,
        maxVersion: maxVersion,
        specVersionHash: specVersionHash,
        libraryVersionHash: libraryVersionHash);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint16(0, version, Endian.little);
    data_.setUint16(2, minVersion, Endian.little);
    data_.setUint16(4, maxVersion, Endian.little);
    MavlinkMessage.setUint8List(data_, 6, specVersionHash);
    MavlinkMessage.setUint8List(data_, 14, libraryVersionHash);
    return data_;
  }
}

class MavlinkDialectMinimal implements MavlinkDialect {
  static const int mavlinkVersion = 3;

  @override
  int get version => mavlinkVersion;

  @override
  MavlinkMessage? parse(int messageID, ByteData data) {
    switch (messageID) {
      case 0:
        return Heartbeat.parse(data);
      case 300:
        return ProtocolVersion.parse(data);
      default:
        return null;
    }
  }

  @override
  int crcExtra(int messageID) {
    switch (messageID) {
      case 0:
        return Heartbeat._mavlinkCrcExtra;
      case 300:
        return ProtocolVersion._mavlinkCrcExtra;
      default:
        return -1;
    }
  }
}
