import 'package:flutter/widgets.dart';

import 'translator.dart';

extension StringExtension on String {
  String translate(
    BuildContext context, {
    List<String>? parent,
    int? pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  }) =>
      Translator.of(context)?.translate(
        this,
        parent: parent,
        pluralValue: pluralValue,
        args: args,
        namedArgs: namedArgs,
      ) ??
      '';
}

extension ContextTranslator on BuildContext {
  String translate(
    String key, {
    List<String>? parent,
    int? pluralValue,
    List<String>? args,
    Map<String, dynamic>? namedArgs,
  }) =>
      Translator.of(this)?.translate(
        key,
        parent: parent,
        pluralValue: pluralValue,
        args: args,
        namedArgs: namedArgs,
      ) ??
      '';

  Translator? get translator => Translator.of(this);
}
