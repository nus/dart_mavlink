library dart_mavlink;

import 'dart:typed_data';

abstract class MavlinkMessage {
  factory MavlinkMessage.parse(ByteData data) {
    throw UnimplementedError('Implement this constructor on inheriting class');
  }

  int get mavlinkMessageId;
  int get mavlinkCrcExtra;

  ByteData serialize();

  static Int8List asInt8List(ByteData data, int offsetInBytes, int length) {
    Int8List ret = Int8List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getInt8(offsetInBytes + i);
    }

    return ret;
  }

  static Uint8List asUint8List(ByteData data, int offsetInBytes, int length) {
    Uint8List ret = Uint8List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getUint8(offsetInBytes + i);
    }

    return ret;
  }

  static Int16List asInt16List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Int16List ret = Int16List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getInt16(offsetInBytes + (i * 2), endian);
    }

    return ret;
  }

  static Uint16List asUint16List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Uint16List ret = Uint16List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getUint16(offsetInBytes + (i * 2), endian);
    }

    return ret;
  }

  static Int32List asInt32List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Int32List ret = Int32List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getInt32(offsetInBytes + (i * 4), endian);
    }

    return ret;
  }

  static Uint32List asUint32List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Uint32List ret = Uint32List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getUint32(offsetInBytes + (i * 4), endian);
    }

    return ret;
  }

  static Int64List asInt64List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Int64List ret = Int64List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getInt64(offsetInBytes + (i * 8), endian);
    }

    return ret;
  }
  
  static Uint64List asUint64List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Uint64List ret = Uint64List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getUint64(offsetInBytes + (i * 8), endian);
    }

    return ret;
  }

  static Float32List asFloat32List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Float32List ret = Float32List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getFloat32(offsetInBytes + (i * 4), endian);
    }

    return ret;
  }

  static Float64List asFloat64List(ByteData data, int offsetInBytes, int length, [Endian endian=Endian.little]) {
    Float64List ret = Float64List(length);
    for (var i = 0; i < length; i++) {
      ret[i] = data.getFloat64(offsetInBytes + (i * 8), endian);
    }

    return ret;
  }

  static void setInt8List(ByteData data, int offsetByte, List<int> list) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setInt8(offsetByte + i, list[i]);
    }
  }

  static void setUint8List(ByteData data, int offsetByte, List<int> list) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setUint8(offsetByte + i, list[i]);
    }
  }

  static void setInt16List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setInt16(offsetByte + (i * 2), list[i], endian);
    }
  }

  static void setUint16List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setUint16(offsetByte + (i * 2), list[i], endian);
    }
  }

  static void setInt32List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setInt32(offsetByte + (i * 4), list[i], endian);
    }
  }

  static void setUint32List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setUint32(offsetByte + (i * 4), list[i], endian);
    }
  }

  static void setInt64List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setInt64(offsetByte + (i * 8), list[i], endian);
    }
  }

  static void setUint64List(ByteData data, int offsetByte, List<int> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setUint64(offsetByte + (i * 8), list[i], endian);
    }
  }

  static void setFloat32List(ByteData data, int offsetByte, List<double> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setFloat32(offsetByte + (i * 4), list[i], endian);
    }
  }

  static void setFloat64List(ByteData data, int offsetByte, List<double> list, [Endian endian=Endian.little]) {
    int len = list.length;
    for (int i = 0; i < len; i++) {
      data.setFloat64(offsetByte + (i * 8), list[i], endian);
    }
  }
}
