import 'package:flutter/widgets.dart';

import 'translator.dart';

class InternationalizationDelegate extends LocalizationsDelegate<Translator> {
  final String _translationsPath;
  final List<Locale> _suportedLocales;
  final List<String> _files;

  InternationalizationDelegate({
    @required String translationsPath,
    @required List<Locale> suportedLocales,
    @required List<String> files,
  })  : assert(
          translationsPath != null && translationsPath.isNotEmpty,
          "translationsPath can't be null or empty",
        ),
        assert(
          suportedLocales != null && suportedLocales.isNotEmpty,
          "suportedLocales can't be null or empty",
        ),
        assert(
          files != null && files.isNotEmpty,
          "files can't be null or empty",
        ),
        _translationsPath = translationsPath,
        _suportedLocales = suportedLocales,
        _files = files;

  @override
  bool isSupported(Locale locale) => _suportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);

  @override
  Future<Translator> load(Locale locale) async {
    final translator = Translator.newInstance(
      _translationsPath,
      locale,
      _files
    );

    await translator.load();
    
    return translator;
  }

  @override
  bool shouldReload(InternationalizationDelegate old) => false;
}
