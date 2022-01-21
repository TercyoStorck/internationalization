part of 'translator.dart';

class InternationalizationDelegate extends LocalizationsDelegate<Translator> {
  final String _translationsPath;
  final List<Locale> _suportedLocales;
  final Future<Map<String, dynamic>> Function(Locale locale)? addTranslations;

  InternationalizationDelegate({
    required List<Locale> suportedLocales,
    String translationsPath = "assets/translations/",
    this.addTranslations,
  })  : assert(
          suportedLocales.isNotEmpty,
          "suportedLocales can't be null or empty",
        ),
        _translationsPath = translationsPath.endsWith('/')
            ? translationsPath
            : '$translationsPath/',
        _suportedLocales = suportedLocales;

  @override
  bool isSupported(Locale locale) => _suportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);

  @override
  Future<Translator> load(Locale locale) async {
    Map<String, dynamic> externalTranslations = {};

    if (this.addTranslations != null) {
      final translations = await this.addTranslations!(locale);
      externalTranslations.addAll(translations);
    }

    final translator = Translator._(
      locale,
      _translationsPath,
      externalTranslations,
    );

    await translator._load();

    return translator;
  }

  @override
  bool shouldReload(InternationalizationDelegate old) => false;
}
