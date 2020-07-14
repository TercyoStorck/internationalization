import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'src/string_extension.dart';

String _stringsPath;
String _suportedLocales;
List<String> _filesName = [];
List<String> _clazzes = [];
List<String> _clazzInstances = [];

//TODO: refactor the code!!

void main(List<String> arguments) async {
  final yaml = _getConfigurations();
  _stringsPath = _path(yaml);
  _suportedLocales = _locales(yaml);

  final jsonPath = _jsonPath(yaml);

  Directory dir = Directory(jsonPath);

  var files = dir.listSync(recursive: false);

  for (FileSystemEntity fileEntity in files) {
    final file = fileEntity as File;

    final fileName = file.path.split(path.separator).last.split('.').first;
    final clazzName = "_${file.path.split(path.separator).last.split('.').first.capitalize()}";

    final String fileContent = file.readAsStringSync();

    try {
      Map<String, dynamic> fileContentMap = json.decode(fileContent);

      final instance = "  static $clazzName get ${fileName.uncapitalize()} => const $clazzName();";
      final clazz = _clazz(clazzName, fileContentMap);

      _clazzInstances.add(instance);
      _clazzes.add(clazz);
      _filesName.add("    \"$fileName\"");
    } on FormatException catch (_) {
      print(" ${file.path.split('/').last} is in an invalid format");
    }
  }

  final fileFullPath = _fileFullPath(yaml);

  final genFile = File(fileFullPath);

  if (genFile.existsSync()) {
    genFile.deleteSync();
  }

  genFile.createSync(recursive: true);
  var sink = genFile.openWrite();
  sink.write(_file);
  await sink.flush();
  await sink.close();
  print("Internationalization build done!");
}

Map _getConfigurations() {
  final File file = File('pubspec.yaml');
  final String yamlString = file.readAsStringSync();
  final Map yamlMap = loadYaml(yamlString);
  return yamlMap["internationalization"];
}

String _path(Map yaml) {
  final String path = yaml["path"];
  return path.endsWith("/") ? path : "$path/";
}

String _locales(Map yaml) {
  final locales = (yaml["locales"] as List)
      ?.map(
        (locale) =>
            locale["countries-code"]
                ?.map(
                  (countryCode) =>
                      "    Locale('${locale["language-code"]}', '$countryCode')",
                )
                ?.toList() ??
            ["    Locale('${locale["language-code"]}')"],
      )
      ?.toList()
      ?.reduce(
        (l1, l2) =>
            List.castFrom<dynamic, String>(l1).toList() +
            List.castFrom<dynamic, String>(l2).toList(),
      );

  return "[\n${locales.join(',\n')},\n  ]";
}

String _jsonPath(Map yaml) {
  final language = yaml['locales'].first['language-code'];

  final country = yaml['locales']?.first['countries-code']?.first ?? "";

  return "${_path(yaml)}$language/$country";
}

String _clazz(String clazzName, Map<String, dynamic> content) {
  final keys = [];

  for (String key in content.keys) {
    final array = key.split('_');
    final sb = StringBuffer();
    
    for (var item in array) {
      sb.write(item.capitalize());
    }

    final methodName = sb.toString().uncapitalize();

    keys.add('''
  String $methodName({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "$key".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);''');
  }

  return ''' 
class $clazzName {
  const $clazzName();

${keys.join('\n')}
}''';
}

String _fileFullPath(Map yaml) {
  final fileName = "internationalization.gen.dart";
  final outPutPath = yaml['output-path'] ?? "";

  if (outPutPath.isEmpty) {
    return "lib/$fileName";
  }

  if (!outPutPath.startsWith("lib/")) {
    return "lib/${outPutPath.first}/$fileName";
  }

  return "$outPutPath/$fileName";
}

final _file = '''//GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Internationalization
// **************************************************************************

import 'package:flutter/widgets.dart';
import 'package:internationalization/internationalization.dart';

class Intl {
  static String get stringsPath => "$_stringsPath";
  static List<Locale> get suportedLocales => $_suportedLocales;
  static List<String> get files => [\n${_filesName.join(',\n')}\n  ];

${_clazzInstances.join('\n')}
}

${_clazzes.join('\n\n')}

''';
