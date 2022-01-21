import 'package:flutter/widgets.dart';

import 'translator.dart';

extension StringExtension on String {
  String translate(
    BuildContext context, {
    String? translationContext,
    int? pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  }) => Translator.of(context)?.translate(
        this,
        translationContext: translationContext,
        pluralValue: pluralValue,
        args: args,
        namedArgs: namedArgs,
      ) ??
      '';
}

extension ContextTranslator on BuildContext {
  String translate(
    String key, {
    String? translationContext,
    int? pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  }) =>
      Translator.of(this)?.translate(
        key,
        translationContext: translationContext,
        pluralValue: pluralValue,
        args: args,
        namedArgs: namedArgs,
      ) ??
      '';

  Translator? get translator => Translator.of(this);
}
