import 'dart:typed_data';
import 'package:dart_mavlink/mavlink_dialect.dart';
import 'package:dart_mavlink/mavlink_message.dart';
import 'package:dart_mavlink/types.dart';

///
/// ICAROUS_TRACK_BAND_TYPES
typedef IcarousTrackBandTypes = int;

///
/// ICAROUS_TRACK_BAND_TYPE_NONE
const IcarousTrackBandTypes icarousTrackBandTypeNone = 0;

///
/// ICAROUS_TRACK_BAND_TYPE_NEAR
const IcarousTrackBandTypes icarousTrackBandTypeNear = 1;

///
/// ICAROUS_TRACK_BAND_TYPE_RECOVERY
const IcarousTrackBandTypes icarousTrackBandTypeRecovery = 2;

///
/// ICAROUS_FMS_STATE
typedef IcarousFmsState = int;

///
/// ICAROUS_FMS_STATE_IDLE
const IcarousFmsState icarousFmsStateIdle = 0;

///
/// ICAROUS_FMS_STATE_TAKEOFF
const IcarousFmsState icarousFmsStateTakeoff = 1;

///
/// ICAROUS_FMS_STATE_CLIMB
const IcarousFmsState icarousFmsStateClimb = 2;

///
/// ICAROUS_FMS_STATE_CRUISE
const IcarousFmsState icarousFmsStateCruise = 3;

///
/// ICAROUS_FMS_STATE_APPROACH
const IcarousFmsState icarousFmsStateApproach = 4;

///
/// ICAROUS_FMS_STATE_LAND
const IcarousFmsState icarousFmsStateLand = 5;

/// ICAROUS heartbeat
///
/// ICAROUS_HEARTBEAT
class IcarousHeartbeat implements MavlinkMessage {
  static const int _mavlinkMessageId = 42000;

  static const int _mavlinkCrcExtra = 227;

  static const int mavlinkEncodedLength = 1;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// See the FMS_STATE enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousFmsState]
  ///
  /// status
  final IcarousFmsState status;

  IcarousHeartbeat({
    required this.status,
  });

  IcarousHeartbeat copyWith({
    IcarousFmsState? status,
  }) {
    return IcarousHeartbeat(
      status: status ?? this.status,
    );
  }

  factory IcarousHeartbeat.parse(ByteData data_) {
    if (data_.lengthInBytes < IcarousHeartbeat.mavlinkEncodedLength) {
      var len = IcarousHeartbeat.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var status = data_.getUint8(0);

    return IcarousHeartbeat(status: status);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint8(0, status);
    return data_;
  }
}

/// Kinematic multi bands (track) output from Daidalus
///
/// ICAROUS_KINEMATIC_BANDS
class IcarousKinematicBands implements MavlinkMessage {
  static const int _mavlinkMessageId = 42001;

  static const int _mavlinkCrcExtra = 239;

  static const int mavlinkEncodedLength = 46;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// min angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// min1
  final float min1;

  /// max angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// max1
  final float max1;

  /// min angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// min2
  final float min2;

  /// max angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// max2
  final float max2;

  /// min angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// min3
  final float min3;

  /// max angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// max3
  final float max3;

  /// min angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// min4
  final float min4;

  /// max angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// max4
  final float max4;

  /// min angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// min5
  final float min5;

  /// max angle (degrees)
  ///
  /// MAVLink type: float
  ///
  /// units: deg
  ///
  /// max5
  final float max5;

  /// Number of track bands
  ///
  /// MAVLink type: int8_t
  ///
  /// numBands
  final int8_t numbands;

  /// See the TRACK_BAND_TYPES enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousTrackBandTypes]
  ///
  /// type1
  final IcarousTrackBandTypes type1;

  /// See the TRACK_BAND_TYPES enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousTrackBandTypes]
  ///
  /// type2
  final IcarousTrackBandTypes type2;

  /// See the TRACK_BAND_TYPES enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousTrackBandTypes]
  ///
  /// type3
  final IcarousTrackBandTypes type3;

  /// See the TRACK_BAND_TYPES enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousTrackBandTypes]
  ///
  /// type4
  final IcarousTrackBandTypes type4;

  /// See the TRACK_BAND_TYPES enum.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [IcarousTrackBandTypes]
  ///
  /// type5
  final IcarousTrackBandTypes type5;

  IcarousKinematicBands({
    required this.min1,
    required this.max1,
    required this.min2,
    required this.max2,
    required this.min3,
    required this.max3,
    required this.min4,
    required this.max4,
    required this.min5,
    required this.max5,
    required this.numbands,
    required this.type1,
    required this.type2,
    required this.type3,
    required this.type4,
    required this.type5,
  });

  IcarousKinematicBands copyWith({
    float? min1,
    float? max1,
    float? min2,
    float? max2,
    float? min3,
    float? max3,
    float? min4,
    float? max4,
    float? min5,
    float? max5,
    int8_t? numbands,
    IcarousTrackBandTypes? type1,
    IcarousTrackBandTypes? type2,
    IcarousTrackBandTypes? type3,
    IcarousTrackBandTypes? type4,
    IcarousTrackBandTypes? type5,
  }) {
    return IcarousKinematicBands(
      min1: min1 ?? this.min1,
      max1: max1 ?? this.max1,
      min2: min2 ?? this.min2,
      max2: max2 ?? this.max2,
      min3: min3 ?? this.min3,
      max3: max3 ?? this.max3,
      min4: min4 ?? this.min4,
      max4: max4 ?? this.max4,
      min5: min5 ?? this.min5,
      max5: max5 ?? this.max5,
      numbands: numbands ?? this.numbands,
      type1: type1 ?? this.type1,
      type2: type2 ?? this.type2,
      type3: type3 ?? this.type3,
      type4: type4 ?? this.type4,
      type5: type5 ?? this.type5,
    );
  }

  factory IcarousKinematicBands.parse(ByteData data_) {
    if (data_.lengthInBytes < IcarousKinematicBands.mavlinkEncodedLength) {
      var len =
          IcarousKinematicBands.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var min1 = data_.getFloat32(0, Endian.little);
    var max1 = data_.getFloat32(4, Endian.little);
    var min2 = data_.getFloat32(8, Endian.little);
    var max2 = data_.getFloat32(12, Endian.little);
    var min3 = data_.getFloat32(16, Endian.little);
    var max3 = data_.getFloat32(20, Endian.little);
    var min4 = data_.getFloat32(24, Endian.little);
    var max4 = data_.getFloat32(28, Endian.little);
    var min5 = data_.getFloat32(32, Endian.little);
    var max5 = data_.getFloat32(36, Endian.little);
    var numbands = data_.getInt8(40);
    var type1 = data_.getUint8(41);
    var type2 = data_.getUint8(42);
    var type3 = data_.getUint8(43);
    var type4 = data_.getUint8(44);
    var type5 = data_.getUint8(45);

    return IcarousKinematicBands(
        min1: min1,
        max1: max1,
        min2: min2,
        max2: max2,
        min3: min3,
        max3: max3,
        min4: min4,
        max4: max4,
        min5: min5,
        max5: max5,
        numbands: numbands,
        type1: type1,
        type2: type2,
        type3: type3,
        type4: type4,
        type5: type5);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setFloat32(0, min1, Endian.little);
    data_.setFloat32(4, max1, Endian.little);
    data_.setFloat32(8, min2, Endian.little);
    data_.setFloat32(12, max2, Endian.little);
    data_.setFloat32(16, min3, Endian.little);
    data_.setFloat32(20, max3, Endian.little);
    data_.setFloat32(24, min4, Endian.little);
    data_.setFloat32(28, max4, Endian.little);
    data_.setFloat32(32, min5, Endian.little);
    data_.setFloat32(36, max5, Endian.little);
    data_.setInt8(40, numbands);
    data_.setUint8(41, type1);
    data_.setUint8(42, type2);
    data_.setUint8(43, type3);
    data_.setUint8(44, type4);
    data_.setUint8(45, type5);
    return data_;
  }
}

class MavlinkDialectIcarous implements MavlinkDialect {
  static const int mavlinkVersion = 0;

  @override
  int get version => mavlinkVersion;

  @override
  MavlinkMessage? parse(int messageID, ByteData data) {
    switch (messageID) {
      case 42000:
        return IcarousHeartbeat.parse(data);
      case 42001:
        return IcarousKinematicBands.parse(data);
      default:
        return null;
    }
  }

  @override
  int crcExtra(int messageID) {
    switch (messageID) {
      case 42000:
        return IcarousHeartbeat._mavlinkCrcExtra;
      case 42001:
        return IcarousKinematicBands._mavlinkCrcExtra;
      default:
        return -1;
    }
  }
}
