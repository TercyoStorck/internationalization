import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'localization_delegate.dart';

class Translator {
  final String _translationsPath;
  final Locale _locale;
  final Map<String, dynamic> _translations = {};

  Translator._(
    this._locale,
    this._translationsPath,
    Map<String, dynamic> externalTranslations,
  ) {
    _translations.addAll(externalTranslations);
  }

  static Translator? of(BuildContext context) {
    return Localizations.of<Translator>(context, Translator);
  }

  Future<void> _load() async {
    final filePath = _pathJsonStrings(this._locale);
    final data = await rootBundle.loadString(filePath);
    final translations = json.decode(data);
    _translations.addAll(translations);
  }

  String _pathJsonStrings(Locale locale) {
    if (locale.countryCode?.isEmpty != false) {
      return '$_translationsPath${locale.languageCode.toLowerCase()}.json';
    }

    return '$_translationsPath${locale.languageCode.toLowerCase()}/${locale.countryCode!.toLowerCase()}.json';
  }

  String _interpolateValue(
    String value,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  ) {
    for (int i = 0; i < (args?.length ?? 0); i++) {
      value = value.replaceAll("{$i}", args![i]);
    }

    if (namedArgs?.isNotEmpty == true) {
      namedArgs!.forEach(
        (entryKey, entryValue) => value = value.replaceAll(
          "::$entryKey::",
          entryValue.toString(),
        ),
      );
    }

    return value;
  }

  Map<String, dynamic> _foundKeyValue(List<String>? parent) {
    Map<String, dynamic> translations = _translations;

    for (var element in parent ?? []) {
      translations = translations[element];
    }

    return translations;
  }

  String _valueOf(
    List<String>? parent,
    String key,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  ) {
    final value = _foundKeyValue(parent)[key];

    if (value != null) {
      return _interpolateValue(value, args, namedArgs);
    }

    return key;
  }

  String _pluralOf(
    List<String>? parent,
    String key,
    int pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  ) {
    final Map<String, dynamic> plurals = _foundKeyValue(parent)[key];

    final plural = {0: "zero", 1: "one"}[pluralValue] ?? "other";
    String value = plurals[plural].toString();
    value = _interpolateValue(value, args, namedArgs);

    return value;
  }

  void addExternalTranslations(Map<String, dynamic> translations) {
    _translations.addAll(translations);
  }

  String translate(
    String key, {
    List<String>? parent,
    int? pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  }) {
    if (pluralValue != null) {
      return _pluralOf(
        parent,
        key,
        pluralValue,
        args,
        namedArgs,
      );
    }

    return _valueOf(
      parent,
      key,
      args,
      namedArgs,
    );
  }
}
