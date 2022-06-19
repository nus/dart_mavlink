library dart_mavlink;

class CrcX25 {
  static final _x25InitCrc = 0xffff;

  int _crc = _x25InitCrc;

  int get crc => _crc & 0xffff;

  void accumulate(int byte) {
      byte = byte & 0xff; // For cast as byte.

      int tmp = byte ^ (_crc &0xff);
      tmp &= 0xff;
      tmp ^= ((tmp<<4) & 0xff);

      _crc = (_crc>>8) ^ ((tmp<<8) &0xffff) ^ ((tmp <<3) &0xffff)^ (tmp>>4);
  }

  void accumulateString(String str) {
    for (var i in str.codeUnits) {
      accumulate(i);
    }
  }
}
