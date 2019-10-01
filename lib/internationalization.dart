library internationalization;

import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

String _path;
Locale _defaultLocale;
List<Locale> _suportedLocales;

Iterable<Locale> get suportedLocales => _suportedLocales;

Future<Map> _getConfigurations() async {
  String yamlFile = await rootBundle.loadString("./internationalization.yaml");
  return  loadYaml(yamlFile);
}

_loadAssetsStringPath(Map yaml) {
  _path = yaml["path"];
}

_loadSuportedLocales(Map yaml) {
  _suportedLocales = yaml["locales"].map<Locale>(
        (locale) {
          final language = locale["locale"]["language"];
          final country = locale["locale"]["country"];

          return Locale(language, country);
        }).toList();
}

_loadDefaultLocale(Map yaml) {
  final language = yaml["default_locale"]["language"] ?? null;
  final country = yaml["default_locale"]["country"] ?? null;

  _defaultLocale = Locale(language, country);
}

class Strings {
  static final Map<String, dynamic> _defaultLocaleStrings = new Map();
  final Locale _locale;
  Map<String, dynamic> _locationStrings;

  Strings._(this._locale);

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  _load() async {
    await _loadDefault();

    if(_locale == _defaultLocale) {
      return;
    }

    String data = await rootBundle.loadString(_pathJsonStrings(this._locale));
    _locationStrings = json.decode(data);
  }

  _loadDefault() async {
    if (_defaultLocaleStrings.isNotEmpty) {
      return;
    }

    String data = await rootBundle.loadString(_pathJsonStrings(_defaultLocale));
    Map<String, dynamic> _result = json.decode(data);

    _result.forEach((String key, dynamic value) {
      _defaultLocaleStrings[key] = value;
    });
  }

  String _pathJsonStrings(Locale locale) {
    if(locale?.countryCode?.isEmpty != false) {
      return '$_path/${locale.languageCode}.json';
    }

    return '$_path/${locale.languageCode}_${locale.countryCode}.json';
  }

  bool _stringExists(String key) => _locationStrings?.containsKey(key) == true || _defaultLocaleStrings?.containsKey(key) == true;

  dynamic _valueOf(String key) {
    if (_locationStrings == null) {
      return _defaultLocaleStrings[key];
    }

    return _locationStrings[key] ?? _defaultLocaleStrings[key];
  }
  
  String _interpolateValue(String value, List<String> args, Map<String, dynamic> namedArgs) {
    for (int i = 0; i < (args?.length ?? 0); i++) {
      value = value.replaceAll("{$i}", args[i]);
    }

    if (namedArgs?.isNotEmpty == true) {
      namedArgs.forEach((entryKey, entryValue) => value = value.replaceAll("::$entryKey::", entryValue.toString()));
    }

    return value;
  }

  String valueOf(String key, {List<String> args, Map<String, dynamic> namedArgs}) {
    if (!_stringExists(key)) {
      return key;
    }

    String value = _valueOf(key).toString();

    value = _interpolateValue(value, args, namedArgs);

    return value;
  }

  String pluralOf(String key, int pluralValue, {List<String> args, Map<String, dynamic> namedArgs}) {
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

class _InternationalizationDelegate extends LocalizationsDelegate<Strings> {
  const _InternationalizationDelegate();

  @override
  bool isSupported(Locale locale) => _suportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) async {
    Strings strings = Strings._(locale);
    await strings._load();
    return strings;
  }

  @override
  bool shouldReload(_InternationalizationDelegate old) => false;
}

abstract class Internationalization {
  static const LocalizationsDelegate<Strings> delegate = _InternationalizationDelegate();
  
  static loadConfigurations() async {
    Map yaml = await _getConfigurations();

    _loadAssetsStringPath(yaml);
    _loadSuportedLocales(yaml);
    _loadDefaultLocale(yaml);
  }
}