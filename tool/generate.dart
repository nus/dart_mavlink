import 'dart:io';
import 'dart:collection';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;
import 'package:dart_mavlink/crc.dart';

class DialectEnums extends IterableMixin<DialectEnum> {
  final List<DialectEnum> _enums;

  DialectEnums(this._enums);

  @override
  Iterator<DialectEnum> get iterator => _enums.iterator;

  @override
  int get length => _enums.length;

  void addAll(DialectEnums iterable) {
    for (var e in iterable) {
      if (_hasName(e.name)) {
        continue;
      }

      _enums.add(e);
    }
  }

  bool _hasName(String name) {
    for (var e in _enums) {
      if (e.name == name) {
        return true;
      }
    }
    return false;
  }

  static DialectEnums parseElement(XmlElement? elmEnums) {
    if (elmEnums == null) {
      return DialectEnums([]);
    }

    List<DialectEnum> enums = [];
    for (var elmEnum in elmEnums.findAllElements('enum')) {
      String name = elmEnum.getAttribute('name') ?? '';
      if (name.isEmpty) {
        throw FormatException('The name of enum element should not be empty.');
      }

      var description = elmEnum.getElement('description')?.text;

      DialectDeprecated? dlctDeprecated = DialectDeprecated.parseElement(elmEnum.getElement('deprecated'));

      List<DialectEntry>? entries;
      for (var elmEntry in elmEnum.findAllElements('entry')) {
        entries ??= [];

        bool enumIsMavCmd = (name == 'MAV_CMD');
        var dlctEntry = DialectEntry.parseElement(elmEntry, enumIsMavCmd);

        entries.add(dlctEntry);
      }

      enums.add(DialectEnum(name, description, dlctDeprecated, entries));
    }

    return DialectEnums(enums);
  }
}

/// Contains [](https://mavlink.io/en/guide/xml_schema.html#enum)
class DialectEnum {
  /// Mandatory.
  final String name;

  /// Optional.
  final String? description;

  /// Optional
  final DialectDeprecated? deprecated;

  /// Optional
  final List<DialectEntry>? entries;

  final String nameForDart;

  DialectEnum(this.name, this.description, this.deprecated, this.entries)
    : nameForDart = camelCase(name);
}

/// Containes [enum](https://mavlink.io/en/guide/xml_schema.html#entry)
class DialectEntry {
  /// Mandatory.
  final String name;

  /// Optional.
  final int? value;

  /// Optional.
  final String? description;

  /// Optional.
  final DialectDeprecated? deprecated;

  /// Optional.
  final bool wip;

  /// Optional. for MAV_CMD. Default value is true.
  final bool? hasLocation;

  /// Optional. for MAV_CMD. Default value is true.
  final bool? isDestination;

  /// Optional. for MAV_CMD.
  final List<DialectParam>? params;

  final String nameForDart;

  DialectEntry(this.name, this.value, this.description, this.deprecated, this.wip, this.hasLocation, this.isDestination, this.params)
    : nameForDart = lowerCamelCase(name);

  static DialectEntry parseElement(XmlElement elmEntry, bool enumIsMavCmd) {
    String name = elmEntry.getAttribute('name') ?? '';
    if (name.isEmpty) {
      throw FormatException('The name of deprecated element should not be empty.');
    }

    var valueStr = (elmEntry.getAttribute('value') ?? '');
    int value = int.parse(valueStr);
    String? description = elmEntry.getElement('description')?.text;

    var deprecated = DialectDeprecated.parseElement(elmEntry.getElement('deprecated'));

    var wip = (elmEntry.getElement('wip') == null) ? false : true;

    var attrHasLocation = elmEntry.getAttribute('hasLocation');
    var attrIsDestination = elmEntry.getAttribute('isDestination');

    bool? hasLocation;
    bool? isDestination;
    List<DialectParam>? params;
    if (enumIsMavCmd) {
      hasLocation = _castAsBool(attrHasLocation, true);
      isDestination = _castAsBool(attrIsDestination, true);

      var elmParams = elmEntry.findAllElements('param');
      params = List<DialectParam>.generate(7, (index) => DialectParam.empty(index + 1));

      for (int i = 0; i < elmParams.length; i++) {
        var elmParam = elmParams.elementAt(i);

        var index = int.parse(elmParam.getAttribute('index') ?? '');

        var description = elmParam.text;

        params[index - 1] = DialectParam(
          index,
          description,
          elmParam.getAttribute('label'),
          elmParam.getAttribute('units'),
          elmParam.getAttribute('enum'),
          elmParam.getAttribute('decimalPlaces'),
          elmParam.getAttribute('increment'),
          elmParam.getAttribute('minValue'),
          elmParam.getAttribute('maxValue'),
          _castAsBool(elmParam.getAttribute('reserved'), false)
        );
      }
    } else {
      if (attrHasLocation != null || attrIsDestination != null) {
        throw FormatException('The hasLocation attribute and isDestination must be child of MAV_CMD.');
      }
    }


    return DialectEntry(name, value, description, deprecated, wip, hasLocation, isDestination, params);
  }

  static bool _castAsBool(String? str, bool defaultValue) {
    if (str == null) {
      return defaultValue;
    }
    switch (str) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw FormatException('The hasLocation of etnry element should not be true or false but "$str"');
    }
  }
}

class DialectParam {
  /// Mandatory.
  final int index;

  /// Mandatory.
  final String description;

  /// Optional.
  final String? label;

  /// Optional.
  final String? units;

  /// Optional.
  final String? enum_;

  /// Optional.
  final String? decimalPlaces;

  /// Optional.
  final String? increment;

  /// Optional.
  final String? minValue;

  /// Optional.
  final String? maxValue;

  // Optional. Default is false.
  final bool? reserved;

  DialectParam.empty(this.index) :
    description ="",
    label = null,
    units = null,
    enum_ = null,
    decimalPlaces = null,
    increment = null,
    minValue = null,
    maxValue = null,
    reserved = null;

  DialectParam(this.index, this.description, this.label, this.units, this.enum_, this.decimalPlaces, this.increment, this.minValue, this.maxValue, this.reserved);
}

class DialectDeprecated {
  /// Mandatory.
  final String since;

  /// Mandatory. It is possible to be empty string.
  final String replacedBy;

  /// Mandatory. It is possible to be empty string.
  final String text;

  DialectDeprecated(this.since, this.replacedBy, this.text);

  static DialectDeprecated? parseElement(XmlElement? elmDeprecated) {
    if (elmDeprecated == null) {
      return null;
    }

    String since = elmDeprecated.getAttribute('since') ?? '';
    String replacedBy = elmDeprecated.getAttribute('replaced_by') ?? '';
    String text = elmDeprecated.text;

    if (since.isEmpty) {
      throw FormatException('The since of deprecated element should not be empty.');
    }

    return DialectDeprecated(since, replacedBy, text);
  }
}

class DialectMessages extends IterableMixin<DialectMessage> {
  final List<DialectMessage> _messages;

  DialectMessages(this._messages);

  @override
  Iterator<DialectMessage> get iterator => _messages.iterator;

  @override
  int get length => _messages.length;

  void addAll(DialectMessages iterable) {
    for (var m in iterable) {
      if (_hasID(m.id)) {
        continue;
      }

      _messages.add(m);
    }
  }

  bool _hasID(int id) {
    for (var m in _messages) {
      if (m.id == id) {
        return true;
      }
    }
    return false;
  }

  static DialectMessages parseElement(XmlElement? elmMessages) {
    if (elmMessages == null) {
      return DialectMessages([]);
    }

    List<DialectMessage> messages = [];

    for (var elmMessage in elmMessages.findAllElements('message')) {
      int id = int.parse(elmMessage.getAttribute('id') ?? '-1');
      if (id == -1) {
        throw FormatException('The id of message element should not be emtpy.');
      }

      String name = elmMessage.getAttribute('name') ?? '';
      if (name.isEmpty) {
        throw FormatException('The name of message element should not be empty.');
      }

      String? description = elmMessage.getElement('description')?.text;
      if (description == null) {
        throw FormatException('The description of message element should not be empty.');
      }

      DialectDeprecated? dlctDeprecated = DialectDeprecated.parseElement(elmMessage.getElement('deprecated'));

      List<DialectField> fields = [];
      bool isExtenstion = false;
      for (var child in elmMessage.childElements) {
        String name = child.name.toString();
        if (name == 'field') {
          fields.add(DialectField.parseElement(child, isExtenstion));
        } else if (name == 'extensions') {
          isExtenstion = true;
        }
      }

      messages.add(DialectMessage(id, name, description, fields, dlctDeprecated));
    }

    return DialectMessages(messages);
  }
}

class DialectMessage {
  final int id;
  final String name;
  final String description;
  final List<DialectField> fields;

  /// Optional
  final DialectDeprecated? deprecated;

  final String nameForDart;

  /// https://mavlink.io/en/guide/serialization.html#field_reordering
  final List<DialectField> orderedFields;

  DialectMessage(this.id, this.name, this.description, this.fields,this.deprecated)
    : nameForDart = camelCase(name)
    , orderedFields = fields.where((f) => !f.isExtension).toList()
        ..sort((a, b) => b.parsedType.bit.compareTo(a.parsedType.bit))
        ..addAll(fields.where((f) => f.isExtension));

  int calculateCrcExtra() {
    var crc = CrcX25();
    crc.accumulateString(name + ' ');

    for (var f in orderedFields) {
      if (f.isExtension) {
        continue;
      }

      crc.accumulateString(f.unitType + ' ');
      crc.accumulateString(f.name + ' ');

      if (f.parsedType.isArray) {
        crc.accumulate(f.parsedType.arrayLength);
      }
    }

    return (crc.crc & 0xff) ^ (crc.crc >> 8);
  }

  /// Length of message bytes that includes extension fields.
  int calculateEncodedLength() {
    int ret = 0;
    for (var f in fields) {
      var t = f.parsedType;
      ret += (t.bit ~/ 8) * t.arrayLength;
    }

    return ret;
  }
}

class DialectField {
  final String name;
  final String type;
  final String description;
  final bool isExtension;
  final String? units;
  final String? enum_;

  final String nameForDart;

  DialectField(this.name, this.type, this.description, this.isExtension, this.units, this.enum_)
    : nameForDart = lowerCamelCase(name);

  ParsedMavlinkType get parsedType =>
    ParsedMavlinkType.parse(type);

  String get unitType {
    int indexOfBracket = type.indexOf('[');
    if (indexOfBracket == -1) {
      return type;
    }
    return type.substring(0, indexOfBracket);
  }

  static DialectField parseElement(XmlElement? elmFiled, isExtension) {
    if (elmFiled == null) {
      throw FormatException('The filed element must not be null.');
    }

    String name = elmFiled.getAttribute('name') ?? '';
    if (name.isEmpty) {
      throw FormatException('The name of message element should not be empty.');
    }

    String type = elmFiled.getAttribute('type') ?? '';
    if (type.isEmpty) {
      throw FormatException('The type of message element should not be empty.');
    }
    if (type == 'uint8_t_mavlink_version') {
      type = 'uint8_t';
    }

    String description = elmFiled.text;

    String? units = elmFiled.getAttribute('units');
    String? enum_ = elmFiled.getAttribute('enum');

    return DialectField(name, type, description, isExtension, units, enum_);
  }
}

class DialectDocument {
  /// This version is included HEATBEAT mavlink_version.
  int version = -1;
  int dialect = -1;

  /// Enums element. Including enums which is specified by include tags.
  DialectEnums enums;

  /// Messages element. Including messages which is specified by include tags.
  DialectMessages messages;

  DialectDocument(this.version, this.dialect, this.enums, this.messages);

  static Future<DialectDocument> parse(String dialectPath) async {
    var dialectXml = File(dialectPath);
    if (!await dialectXml.exists()) {
      throw Exception('$dialectXml does not exist.');
    }
    String xmlStr = await dialectXml.readAsString();

    int version = 0;
    int dialect = 0;
    DialectEnums dlctEnums = DialectEnums([]);
    DialectMessages dlctMessages = DialectMessages([]);

    XmlDocument xmlDoc = XmlDocument.parse(xmlStr);
    var elmMavlink = xmlDoc.getElement('mavlink');
    var iterElmInclude = elmMavlink?.findAllElements('include') ?? [];
    for (var inc in iterElmInclude) {
      var includingPath = path.join(path.dirname(dialectPath), inc.text);
      var includingDoc = await DialectDocument.parse(includingPath);

      dlctEnums.addAll(includingDoc.enums);
      dlctMessages.addAll(includingDoc.messages);

      // Overwirte values the new include dialect file.
      version = (includingDoc.version == -1) ? version : includingDoc.version;
      dialect = (includingDoc.dialect == -1) ? dialect : includingDoc.dialect;

      // Add/overwrite values.
    }

    // version tag
    var t = elmMavlink?.getElement('version')?.text;
    if (t != null) {
      version = int.parse(t);
    }

    // dialect tag
    t = elmMavlink?.getElement('dialect')?.text;
    if (t != null) {
      dialect = int.parse(t);
    }

    // Enum tag
    dlctEnums.addAll(DialectEnums.parseElement(elmMavlink?.getElement('enums')));

    // Message Definition
    dlctMessages.addAll(DialectMessages.parseElement(elmMavlink?.getElement('messages')));

    return DialectDocument(version, dialect, dlctEnums, dlctMessages);
  }
}

String capitalize(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String camelCase(String s) {
  s = s.toLowerCase();
  var sep = s.split('_');
  return sep.map((e) => capitalize(e)).join('');
}

String lowerCamelCase(String s) {
  s = s.toLowerCase();
  var sep = s.split('_');
  if (sep.length == 1) {
    return sep[0];
  }

  return sep[0] + sep.sublist(1).map((e) => capitalize(e)).join('');
}

String dialectNameFromPath(String p) {
  String b = path.basenameWithoutExtension(p);
  return capitalize(b);
}

enum BasicType {
  int,
  uint,
  float,
}

class ParsedMavlinkType {
  final BasicType type;
  final int bit;

  /// Length of array. 1 or above. 1 means not an array.
  final int arrayLength;

  final String mavlinkType;

  ParsedMavlinkType(this.type, this.bit, this.arrayLength, this.mavlinkType);

  bool get isArray => arrayLength > 1;

  int get byte => bit ~/ 8;

  factory ParsedMavlinkType.parse(String mavlinkType) {
    var m = RegExp(r'(uint|int|char|float|double)(8|16|32|64|)(_t|_t_mavlink_version|)(\[(\d{1,3})\]|)').firstMatch(mavlinkType);
    if ((m == null) || m.groupCount != 5) {
      throw FormatException('Unexpected type, $mavlinkType');
    }

    // print('m: ${[for (var i = 0; i < m.groupCount+1; i++) m.group(i)]}'); // For debugging

    var arrayLength = 1;
    if (m.group(5) != null) {
      // Get array size, 2 or above.
      arrayLength = int.parse(m.group(5)!);
    }

    var t = BasicType.int;  // type
    var b = 8;      // bit
    switch (m.group(1)) {
    case 'int':
      t = BasicType.int;
      b = int.parse(m.group(2)!);
      break;
    case 'uint':
      t = BasicType.uint;
      b = int.parse(m.group(2)!);
      break;
    case 'char':
      t = BasicType.int;
      b = 8;
      break;
    case 'float':
      t = BasicType.float;
      b = 32;
      break;
    case 'double':
      t = BasicType.float;
      b = 64;
      break;
    default:
      throw FormatException('Unexpected type, ${m.group(1)}');
    }

    return ParsedMavlinkType(t, b, arrayLength, mavlinkType);
  }
}

Future<bool> generateCode(String dstPath, String srcDialectPath) async {
  var doc = await DialectDocument.parse(srcDialectPath);

  String content = '';

  content += "import 'dart:typed_data';\n";
  content += "import 'package:dart_mavlink/mavlink_dialect.dart';\n";
  content += "import 'package:dart_mavlink/mavlink_message.dart';\n";
  content += "import 'package:dart_mavlink/types.dart';\n";

  // Write enum fields
  for (var enm in doc.enums) {
    content += '\n';
    if (enm.description != null) {
      content += generateAsDartDocumentation(enm.description!);
    }
    content += '///\n';
    content += '/// ${enm.name}\n';
    content += 'typedef ${enm.nameForDart} = int;\n';

    if (enm.entries != null) {
      for (var entry in enm.entries!) {
        if (entry.wip) {
          content += '/// WIP.\n';
        }
        if (entry.description != null) {
          content += generateAsDartDocumentation(entry.description!);
        }
        content += '///\n';
        content += '/// ${entry.name}\n';
        if (entry.deprecated != null) {
          content += '@Deprecated("Replaced by [${entry.deprecated!.replacedBy}] since ${entry.deprecated!.since}. ${entry.deprecated!.text}")\n';
        }
        content += 'const ${enm.nameForDart} ${entry.nameForDart} = ${entry.value};\n';
      }
    }
  }

  // Wrirte message classes.
  for (var msg in doc.messages) {
    content += generateAsDartDocumentation(msg.description);
    content += '///\n';
    content += '/// ${msg.name}\n';
    content += 'class ${msg.nameForDart} implements MavlinkMessage {\n';
    content += '\n';
    content += 'static const int _mavlinkMessageId = ${msg.id};\n';
    content += '\n';
    content += 'static const int _mavlinkCrcExtra = ${msg.calculateCrcExtra()};\n';
    content += '\n';
    content += 'static const int mavlinkEncodedLength = ${msg.calculateEncodedLength()};\n';

    content +='\n';
    content +='@override int get mavlinkMessageId => _mavlinkMessageId;\n';
    content +='\n';
    content +='@override int get mavlinkCrcExtra => _mavlinkCrcExtra;\n';

    for (var field in msg.orderedFields) {
      content += generateAsDartDocumentation(field.description);
      content += '///\n';
      content += '/// MAVLink type: ${field.type}\n';
      if (field.units != null) {
        content += '///\n';
        content += '/// units: ${field.units!}\n';
      }
      if (field.enum_ != null) {
        content += '///\n';
        content += '/// enum: [${camelCase(field.enum_!)}]\n';
      }
      if (field.isExtension) {
        content += '///\n';
        content += '/// Extensions field for MAVLink 2.\n';
      }
      content += '///\n';
      content += '/// ${field.name}\n';
      content += 'final ${asDartType(field.type, field.enum_)} ${field.nameForDart};\n';
    }
    content += '\n';

    // Constructor
    content += '${msg.nameForDart}({';
    String arrayInitializationCode = '';
    for(var f in msg.orderedFields) {
      content += 'required this.${f.nameForDart}, ';
    }
    if (arrayInitializationCode.isEmpty) {
      content += '});\n';
    } else {
      content += '})\n';
      content += ':' + arrayInitializationCode.substring(0, arrayInitializationCode.length - 1) + ';';
    }
    content += '\n';

    // parse constructor.
    content += '''factory ${msg.nameForDart}.parse(ByteData data_) {
    if (data_.lengthInBytes < ${msg.nameForDart}.mavlinkEncodedLength) {
      var len = ${msg.nameForDart}.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) + List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    ''';

    int byteOffset = 0;
    for(var f in msg.orderedFields) {
      var t = f.parsedType;

      var endianArgument = t.bit == 8 ? '' : ', Endian.little';
      if (t.isArray) {
        // Array type
        switch (t.type) {
        case BasicType.int:
          content += 'var ${f.nameForDart} = MavlinkMessage.asInt${t.bit}List(data_, $byteOffset, ${t.arrayLength});\n';
          break;
        case BasicType.uint:
          content += 'var ${f.nameForDart} = MavlinkMessage.asUint${t.bit}List(data_, $byteOffset, ${t.arrayLength});\n';
          break;
        case BasicType.float:
          content += 'var ${f.nameForDart} = MavlinkMessage.asFloat${t.bit}List(data_, $byteOffset, ${t.arrayLength});\n';
          break;
        }
      } else {
        switch (t.type) {
        case BasicType.int:
          content += 'var ${f.nameForDart} = data_.getInt${t.bit}($byteOffset$endianArgument);\n';
          break;
        case BasicType.uint:
          content += 'var ${f.nameForDart} = data_.getUint${t.bit}($byteOffset$endianArgument);\n';
          break;
        case BasicType.float:
          content += 'var ${f.nameForDart} = data_.getFloat${t.bit}($byteOffset, Endian.little);\n';
          break;
        }
      }

      byteOffset += t.byte * t.arrayLength;
    }
    content += '\n';
    content += 'return ${msg.nameForDart}(';
    content += [
      for(var f in msg.orderedFields)
        '${f.nameForDart}: ${f.nameForDart}'
      ]
      .join(', ');
    content += ');\n';
    content += '}\n';
    content += '\n';

    // serialize
    content += '''@override
ByteData serialize() {
var data_ = ByteData(mavlinkEncodedLength);''';
    byteOffset = 0;
    for(var f in msg.orderedFields) {
      var t = f.parsedType;

      var endianArgument = t.bit == 8 ? '' : ', Endian.little';
      if (t.isArray) {
        switch (t.type) {
        case BasicType.int:
          content += 'MavlinkMessage.setInt${t.bit}List(data_, $byteOffset, ${f.nameForDart});\n';
          break;
        case BasicType.uint:
          content += 'MavlinkMessage.setUint${t.bit}List(data_, $byteOffset, ${f.nameForDart});\n';
          break;
        case BasicType.float:
          content += 'MavlinkMessage.setFloat${t.bit}List(data_, $byteOffset, ${f.nameForDart});\n';
          break;
        }
      } else {
        switch (t.type) {
        case BasicType.int:
          content += 'data_.setInt${t.bit}($byteOffset, ${f.nameForDart}$endianArgument);\n';
          break;
        case BasicType.uint:
          content += 'data_.setUint${t.bit}($byteOffset, ${f.nameForDart}$endianArgument);\n';
          break;
        case BasicType.float:
          content += 'data_.setFloat${t.bit}($byteOffset, ${f.nameForDart}, Endian.little);\n';
          break;
        }
      }

      byteOffset += (t.bit ~/ 8) * t.arrayLength;
    }

    content += 'return data_;\n';
    content += '}\n';

    content += '}\n';
  }

  // Interface for MavlinkDialect.
  String dialectName = dialectNameFromPath(srcDialectPath);
  content += '''
class MavlinkDialect$dialectName implements MavlinkDialect {
static const int mavlinkVersion = ${doc.version};

@override
int get version => mavlinkVersion;

@override
MavlinkMessage? parse(int messageID, ByteData data) {
switch (messageID) {
''';

  for (var msg in doc.messages) {
    content += '''case ${msg.id}:
return ${msg.nameForDart}.parse(data);
''';
  }
  content += 'default:\n';
  content += 'return null;\n';
  content += '}\n';
  content += '}\n';

  content += '''
@override
int crcExtra(int messageID) {
switch (messageID) {
  ''';
  for (var msg in doc.messages) {
    content += '''case ${msg.id}:
return ${msg.nameForDart}._mavlinkCrcExtra;
''';
  }

  content += '''
default:
  return -1;
}
}
}
''';

  var outDart = File(dstPath);
  await outDart.writeAsString(content);
  return true;
}

String generateAsDartDocumentation(String str) 
  => str.split('\n').map((s) => '/// ' + s.trimLeft()).join('\n') + '\n';

String asDartType(String mavlinkType, String? enum_) {
  var basicTypes = [
    'int8_t',
    'uint8_t',
    'int16_t',
    'uint16_t',
    'int32_t',
    'uint32_t',
    'int64_t',
    'uint64_t',
    'char',
    'float',
    'double',
  ];
  for (var type in basicTypes) {
    if (type == mavlinkType) {
      if (enum_ != null) {
        return camelCase(enum_);
      }
      return mavlinkType;
    }
    if (RegExp(type + r'\[\d{1,3}\]').hasMatch(mavlinkType)) {
      if (enum_ != null) {
        return 'List<${camelCase(enum_)}>';
      }
      return 'List<$type>';
    }
  }
  return 'Unknown($mavlinkType)';
}

Future<void> runFormatter(String path) async {
  await Process.run('dart', ['format', path]);
}

void main() async {
  final dir = await Directory('mavlink/message_definitions/v1.0/').list()
    .map((f) => f.path.toString())
    .where((f) =>
      (!f.endsWith('all.xml')) && (!f.contains('test'))
    )
    .toList();

  var dstDir = 'lib/dialects';
  await Directory(dstDir).create(recursive: true);

  for (var xmlPath in dir) {
    print(xmlPath);
    var dartPath = path.join(dstDir, path.basenameWithoutExtension(xmlPath).toLowerCase() + '.dart');
    await generateCode(dartPath, xmlPath);
    await runFormatter(dartPath);
  }
}
