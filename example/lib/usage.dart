import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

class Usage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(Strings.of(context).valueOf("simple_string")),
              Text(Strings.of(context).valueOf("interpolation_string", args: ["IM", "HERE"])),
              Text(Strings.of(context).pluralOf("simple_plurals", 0)),
              Text(Strings.of(context).pluralOf("simple_plurals", 1)),
              Text(Strings.of(context).pluralOf("simple_plurals", 132548132)),
              Text(Strings.of(context).pluralOf("interpolation_plurals", 0, args: ["IM", "HERE"])),
              Text(Strings.of(context).pluralOf("interpolation_plurals", 1, args: ["IM", "HERE"])),
              Text(Strings.of(context).pluralOf("interpolation_plurals", 132548132,args: ["IM", "HERE"])),
              Text(Strings.of(context).valueOf("interpolation_string_with_named_args", args: ["IM"], namedArgs: {"named_arg_key": "Named arg"})),
            ],
          ),
        ],
      ),
    );
  }
}
