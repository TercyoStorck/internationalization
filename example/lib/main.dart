import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

import 'usage.dart';

void main() => runApp(InternationalizationExampleApp());

class InternationalizationExampleApp extends StatelessWidget {
  InternationalizationExampleApp() {
    suportedLocales.addAll([
      const Locale('pt', 'BR'),
      const Locale('en', 'US'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: suportedLocales,
        localizationsDelegates: [
            InternationalizationDelegate(
                defaultLocale: Locale('pt', 'BR'),
                path: "./assets/strings",
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        ],
        home: Usage(),
    );
  }
}