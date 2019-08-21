import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

import 'usage.dart';

void main() => runApp(InternationalizationExampleApp());

class InternationalizationExampleApp extends StatelessWidget {
  InternationalizationExampleApp() {
    suportedLocales.addAll([
      const Locale('pt'),
      const Locale('en', 'US'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: suportedLocales,
        localizationsDelegates: [
            InternationalizationDelegate(
                defaultLocale: Locale('pt'),
                path: "./assets/strings",
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        ],
        home: Usage(),
    );
  }
}


/*class Teste {
  Teste() {
    Query([
      User(),
    ]);
  }
}

class Query{
  final List<Querible> query;

  Query(this.query) {
    query.first.toString();
  }
}

abstract class Querible {}

class User implements Querible {
  @override
  String toString() {
    return this.runtimeType.toString();
  }
}*/