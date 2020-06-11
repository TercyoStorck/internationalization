import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:internationalization/internationalization.dart';

class Translator {
  static Translator _instance;
  static final Map<String, dynamic> _defaultLocaleStrings = new Map();

  final String _translationsPath;
  final Locale _locale;
  final List<String> _files;

  Translator._(this._translationsPath, this._locale, this._files);

  Map<String, dynamic> _locationStrings;

  factory Translator.newInstance(String translationsPath, Locale locale, List<String> files) {
    _instance = Translator._(
      translationsPath,
      locale,
      files
    );

    return _instance;
  }

  static Translator get instance {
    try {
      return Localizations.of<Translator>(
        Internationalization.context,
        Translator,
      );
    } catch (_) {}

    return _instance;
  }

  Future<void> load() async {
    final fullPath = _fullPathJsonStrings(this._locale);

    final data = <String>[];

    for (String file in _files) {
      final json = (await rootBundle.loadString("$fullPath$file.json")).trim();
      final content = json.substring(1, json.length - 1);
      data.add(content);
    }

    final jsonContent = data.join(',');
    _locationStrings = json.decode("{$jsonContent}");
  }

  String _fullPathJsonStrings(Locale locale) {
    if (locale?.countryCode?.isEmpty != false) {
      return '$_translationsPath${locale.languageCode}/';
    }

    return '$_translationsPath${locale.languageCode}/${locale.countryCode}/';
  }

  bool _stringExists(String key) =>
      _locationStrings?.containsKey(key) == true ||
      _defaultLocaleStrings?.containsKey(key) == true;

  dynamic _valueOf(String key) {
    if (_locationStrings == null) {
      return _defaultLocaleStrings[key];
    }

    return _locationStrings[key] ?? _defaultLocaleStrings[key];
  }

  String _interpolateValue(
    String value,
    List<String> args,
    Map<String, dynamic> namedArgs,
  ) {
    for (int i = 0; i < (args?.length ?? 0); i++) {
      value = value.replaceAll("{$i}", args[i]);
    }

    if (namedArgs?.isNotEmpty == true) {
      namedArgs.forEach(
        (entryKey, entryValue) => value = value.replaceAll(
          "::$entryKey::",
          entryValue.toString(),
        ),
      );
    }

    return value;
  }

  String valueOf(
    String key, {
    List<String> args,
    Map<String, dynamic> namedArgs,
  }) {
    if (!_stringExists(key)) {
      return key;
    }

    String value = _valueOf(key).toString();

    value = _interpolateValue(value, args, namedArgs);

    return value;
  }

  String pluralOf(
    String key,
    int pluralValue, {
    List<String> args,
    Map<String, dynamic> namedArgs,
  }) {
    if (!_stringExists(key)) {
      return key;
    }

    Map<String, dynamic> plurals = _valueOf(key);
    final plural = {0: "zero", 1: "one"}[pluralValue] ?? "other";
    String value = plurals[plural].toString();
    value = _interpolateValue(value, args, namedArgs);

    return value;
  }
}
