import 'translator.dart';

extension StringExtension on String {
  String translate({
    int pluralValue,
    List<String> args,
    Map<String, dynamic> namedArgs,
  }) {
    if (pluralValue != null) {
      final translation = Translator.instance.pluralOf(
        this,
        pluralValue,
        args: args,
        namedArgs: namedArgs,
      );

      if (translation != null && translation.isNotEmpty) {
        return translation;
      }
    }

    return Translator.instance.valueOf(
      this,
      args: args,
      namedArgs: namedArgs,
    );
  }
}