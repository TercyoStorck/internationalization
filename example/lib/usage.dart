import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

import 'next_page.dart';

class Usage extends StatelessWidget {
  final _translationContext = 'usage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "simple_string".translate(
                  context,
                  translationContext: _translationContext,
                ),
              ),
              Text(
                context.translate(
                  'interpolation_string',
                  translationContext: _translationContext,
                  args: ["( ͡° ͜ʖ ͡°)"],
                ),
              ),
              Text(
                context.translate(
                  'interpolation_string_with_named_args',
                  translationContext: _translationContext,
                  namedArgs: {"named_arg_key": "( ͡° ͜ʖ ͡°)"},
                ),
              ),
              Text(
                context.translate(
                  'simple_plurals',
                  translationContext: _translationContext,
                  pluralValue: 0,
                ),
              ),
              Text(
                context.translate(
                  'simple_plurals',
                  translationContext: _translationContext,
                  pluralValue: 1,
                ),
              ),
              Text(
                context.translate(
                  'simple_plurals',
                  translationContext: _translationContext,
                  pluralValue: 123456789,
                ),
              ),
              Text(
                context.translate(
                  'interpolation_plurals',
                  translationContext: _translationContext,
                  pluralValue: 0,
                  args: ["( ͡° ͜ʖ ͡°)"],
                ),
              ),
              Text(
                context.translate(
                  'interpolation_plurals',
                  translationContext: _translationContext,
                  pluralValue: 1,
                  args: ["( ͡° ͜ʖ ͡°)"],
                ),
              ),
              Text(
                context.translate(
                  'interpolation_plurals',
                  translationContext: _translationContext,
                  pluralValue: 123456789,
                  args: ["123456789"],
                ),
              ),
              Text(
                context.translate('no_translate_context'),
              ),
              ElevatedButton(
                child: Text(
                  context.translate(
                    'next_page_btn',
                    translationContext: _translationContext,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NextPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
