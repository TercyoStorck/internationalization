library internationalization;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

List<Locale> suportedLocales = [];

class Strings {
  static final Map<String, dynamic> _defaultLocaleStrings = new Map();

  final Locale _locale;
  final Locale _defaultLocale;
  final String _path;

  Map<String, dynamic> _locationStrings;

  Strings._(this._defaultLocale, this._locale, this._path);

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  _load() async {
    await _loadDefault();

    if(_locale == _defaultLocale) {
      return;
    }

    String data = await rootBundle.loadString('${this._path}/${this._locale.languageCode}_${this._locale.countryCode}.json');
    _locationStrings = json.decode(data);
  }

  _loadDefault() async {
    if (_defaultLocaleStrings.isNotEmpty) {
      return;
    }

    String data = await rootBundle.loadString('${this._path}/${this._defaultLocale.languageCode}_${this._defaultLocale.countryCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    _result.forEach((String key, dynamic value) {
      _defaultLocaleStrings[key] = value;
    });
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

class InternationalizationDelegate extends LocalizationsDelegate<Strings> {
  final Locale defaultLocale;
  final String path;

  InternationalizationDelegate({
    this.defaultLocale,
    this.path,
  }): assert(
    defaultLocale != null && path != null
  );

  @override
  bool isSupported(Locale locale) => suportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) async {
    Strings strings = Strings._(this.defaultLocale, locale, this.path);
    await strings._load();
    return strings;
  }

  @override
  bool shouldReload(InternationalizationDelegate old) => false;
}