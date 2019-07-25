library internationalization;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

List<Locale> suportedLocales = [];

class Strings {
  final Locale locale;
  final Locale defaultLocale;
  final String path;
  static final Map<String, dynamic> _defaultLocaleStrings = new Map();

  Map<String, dynamic> _sentences;

  Strings(this.defaultLocale, this.locale, this.path);

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  Future<bool> load() async {
    await _loadDefault();

    String data = await rootBundle.loadString('${this.path}/${this.locale.languageCode}_${this.locale.countryCode}.json');
    _sentences = json.decode(data);
    return true;
  }

  Future _loadDefault() async {
    if (_defaultLocaleStrings.isNotEmpty) {
      return;
    }

    String data = await rootBundle.loadString('${this.path}/${this.defaultLocale.languageCode}_${this.defaultLocale.countryCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    _result.forEach((String key, dynamic value) {
      _defaultLocaleStrings[key] = value;
    });
  }

  String valueOf(String key, {List<String> args}) {
    if (_hasKey(key)) {
      return key;
    }

    String value = _sentences[key]?.toString() ?? _defaultLocaleStrings[key]?.toString();

    value = interpolateValue(value, args);

    return value;
  }

  String pluralOf(String key, int pluralValue, {List<String> args}) {
    if (_hasKey(key)) {
      return key;
    }

    Map<String, dynamic> plurals = _sentences[key] ?? _defaultLocaleStrings[key];
    final plural = {0: "zero", 1: "one"}[pluralValue] ?? "other";
    String value = plurals[plural].toString();
    value = interpolateValue(value, args);

    return value;
  }

  bool _hasKey(String key) => _sentences == null && _defaultLocaleStrings.isEmpty || !_sentences.containsKey(key) && !_defaultLocaleStrings.containsKey(key);

  String interpolateValue(String value, List<String> args) {
    for (int i = 0; i < (args?.length ?? 0); i++) {
      value = value.replaceAll("{$i}", args[i]);
    }

    return value;
  }
}

class InternationalizationDelegate extends LocalizationsDelegate<Strings> {
  final Locale defaultLocale;
  final String path;

  InternationalizationDelegate({
    this.defaultLocale,
    this.path,
  });

  @override
  bool isSupported(Locale locale) => suportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) async {
    Strings localizations = new Strings(this.defaultLocale, locale, this.path);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(InternationalizationDelegate old) => false;
}