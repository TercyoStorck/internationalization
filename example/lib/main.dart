import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

import 'infra/res/internationalization.gen.dart';
import 'usage.dart';

void main() => runApp(InternationalizationExampleApp());

class InternationalizationExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: Intl.suportedLocales,
      localizationsDelegates: [
        InternationalizationDelegate(
          translationsPath: Intl.stringsPath,
          suportedLocales: Intl.suportedLocales,
          files: Intl.files,
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Usage(),
    );
  }
}
