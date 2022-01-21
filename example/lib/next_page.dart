import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

class NextPage extends StatelessWidget {
  final _translationContext = 'nextPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate(
            'title',
            translationContext: _translationContext,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              context.translate(
                'wellcome_label',
                translationContext: _translationContext,
              ),
            ),
            Text(
              context.translate('no_translate_context'),
            ),
          ],
        ),
      ),
    );
  }
}
