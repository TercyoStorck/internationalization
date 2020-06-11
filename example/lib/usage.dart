import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

import 'infra/res/internationalization.gen.dart';
import 'next_page.dart';

class Usage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Internationalization.of(context);

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("simple_string".translate()),
              Text(Intl.usage.interpolationString(args: ["( ͡° ͜ʖ ͡°)"])),
              Text(
                Intl.usage.interpolationStringWithNamedArgs(
                  namedArgs: {"named_arg_key": "( ͡° ͜ʖ ͡°)"},
                ),
              ),
              Text(Intl.usage.simplePlurals(pluralValue: 0)),
              Text(Intl.usage.simplePlurals(pluralValue: 1)),
              Text(Intl.usage.simplePlurals(pluralValue: 123456789)),
              Text(
                Intl.usage.interpolationPlurals(
                  pluralValue: 0,
                  args: ["( ͡° ͜ʖ ͡°)"],
                ),
              ),
              Text(
                Intl.usage.interpolationPlurals(
                  pluralValue: 1,
                  args: ["( ͡° ͜ʖ ͡°)"],
                ),
              ),
              Text(
                Intl.usage.interpolationPlurals(
                  pluralValue: 123456789,
                  args: ["123456789"],
                ),
              ),
              RaisedButton(
                child: Text(Intl.usage.nextPageBtn()),
                onPressed: () {
                  return Navigator.of(context).push(
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
