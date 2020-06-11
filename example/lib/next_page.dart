import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

import 'infra/res/internationalization.gen.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Internationalization.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(Intl.next_page.title()),),
      body: Center(
        child: Text(Intl.next_page.wellcomeLabel()),
      ),
    );
  }
}
