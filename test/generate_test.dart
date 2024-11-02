import 'package:test/test.dart';

import '../tool/generate.dart' as generate;

void main() {
  test('Parse t00', () async {
    var dialectDoc = await generate.DialectDocument.parse('test/mavlink_dialect/t00.xml');
    expect(dialectDoc.version, 0);
    expect(dialectDoc.dialect, 0);
  });

  test('Parse t01, with include tag', () async {
    var dialectDoc = await generate.DialectDocument.parse('test/mavlink_dialect/t01.xml');
    expect(dialectDoc.version, 1);
    expect(dialectDoc.dialect, 1);
  });

  test('Parse t02, enums and messages are empty', () async {
    var dialectDoc = await generate.DialectDocument.parse('test/mavlink_dialect/t02.xml');
    expect(dialectDoc.version, 2);
    expect(dialectDoc.dialect, 1);

    expect(dialectDoc.enums.length, 0);
    expect(dialectDoc.messages.length, 0);
  });

  test('Parse t03, contains enums and messages', () async {
    var dialectDoc = await generate.DialectDocument.parse('test/mavlink_dialect/t03.xml');
    expect(dialectDoc.version, 3);
    expect(dialectDoc.dialect, 3);

    expect(dialectDoc.enums.length, 4);

    var e = dialectDoc.enums.elementAt(0);
    expect(e.name, "ENUM_00");
    expect(e.description, isNull);
    expect(e.entries, isNull);

    e = dialectDoc.enums.elementAt(1);
    expect(e.name, "ENUM_01");
    expect(e.description, "Description of ENUM_01");
    expect(e.deprecated?.since, '2021-11');
    expect(e.deprecated?.replacedBy, 'ENUM_02');
    expect(e.deprecated?.text, 'USE ENUM_02');

    var entries = e.entries;
    expect(entries, isNotNull);
    expect(entries?.length, 2);
    expect(entries?.elementAt(0).value, 0);
    expect(entries?.elementAt(0).name, 'ENUM_01_ENTRY_00');
    expect(entries?.elementAt(0).description, 'Description of ENUM_01_ENTRY_00');
    expect(entries?.elementAt(1).value, 1);
    expect(entries?.elementAt(1).name, 'ENUM_01_ENTRY_01');
    expect(entries?.elementAt(1).description, 'Description of ENUM_01_ENTRY_01');

    e = dialectDoc.enums.elementAt(2);
    expect(e.name, "ENUM_02");
    expect(e.description, "Description of ENUM_02");
    expect(e.entries, isNotNull);

    e = dialectDoc.enums.elementAt(3);
    expect(e.name, "ENUM_03");
    entries = e.entries;
    expect(entries?.elementAt(0).value, 1);
    expect(entries?.elementAt(1).value, 2);
    expect(entries?.elementAt(2).value, 4);
    expect(entries?.elementAt(3).value, 8);
    expect(entries?.elementAt(4).value, 16);
    expect(entries?.elementAt(5).value, 32);
    expect(entries?.elementAt(6).value, 64);
    expect(entries?.elementAt(7).value, 128);
    expect(entries?.elementAt(8).value, 1152921504606846976);
    expect(entries?.elementAt(9).value, 2305843009213693952);
    expect(entries?.elementAt(10).value, 4611686018427387904);
  });

  test('Parse t04, name of enums is empty', () async {
    await generate.DialectDocument.parse('test/mavlink_dialect/t04.xml');

  });

  group('parsedMavlinkType', (){
    test('test types', () {
      var t = generate.ParsedMavlinkType.parse('uint8_t');
      expect(t.type, generate.BasicType.uint);
      expect(t.bit, 8);
      expect(t.arrayLength, 1);

      t = generate.ParsedMavlinkType.parse('uint8_t_mavlink_version');
      expect(t.type, generate.BasicType.uint);
      expect(t.bit, 8);
      expect(t.arrayLength, 1);

      // Char as signed char;
      t = generate.ParsedMavlinkType.parse('char');
      expect(t.type, generate.BasicType.int);
      expect(t.bit, 8);
      expect(t.arrayLength, 1);
    });

    test('test array type', () {
      var t = generate.ParsedMavlinkType.parse('uint32_t[8]');
      expect(t.type, generate.BasicType.uint);
      expect(t.bit, 32);
      expect(t.arrayLength, 8);

      t = generate.ParsedMavlinkType.parse('char[25]');
      expect(t.type, generate.BasicType.int);
      expect(t.bit, 8);
      expect(t.arrayLength, 25);
    });
  });

  group('DialectMessage', () {
    test('Check calculating methods', () async {
      var dlctDoc = await generate.DialectDocument.parse('mavlink/message_definitions/v1.0/minimal.xml');
      var msgs = dlctDoc.messages.toList();

      var dlctMessage = msgs[0];
      expect(dlctMessage.name, "HEARTBEAT");
      expect(dlctMessage.calculateCrcExtra(), 50);
      expect(dlctMessage.calculateEncodedLength(), 9);

      // Test a message that contains array fields.
      dlctMessage = msgs[1];
      expect(dlctMessage.name, "PROTOCOL_VERSION");
      expect(dlctMessage.calculateCrcExtra(), 217);
      expect(dlctMessage.calculateEncodedLength(), 22);
    });
  });
}
