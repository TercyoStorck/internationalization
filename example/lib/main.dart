import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

import 'usage.dart';

void main() => runApp(InternationalizationExampleApp());

class InternationalizationExampleApp extends StatelessWidget {
  final _translationsPath = 'assets/translations';
  final _supportedLocales = [
        const Locale('pt', 'BR'),
        const Locale('en', 'US'),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _supportedLocales,
      localizationsDelegates: [
        InternationalizationDelegate(
          translationsPath: _translationsPath,
          suportedLocales: _supportedLocales,
          addTranslations: (locale) async {
            //Here you can get some external json and add to internationalization.
            //!IMPORTANTE: The json must follow the same json structure on assets.
            return {
              'external_translate': 'Translation from external source',
            };
          },
          
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Usage(),
    );
  }
}
