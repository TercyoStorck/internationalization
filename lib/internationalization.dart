library internationalization;

import 'package:flutter/widgets.dart';

export 'package:internationalization/src/localization_delegate.dart';
export 'package:internationalization/src/string_extension.dart';

export 'package:intl/intl.dart' show DateFormat;
export 'package:intl/intl.dart' show NumberFormat;

class Internationalization {
  static BuildContext _context;

  static void of(BuildContext context) => _context = context;
  static BuildContext get context => _context;
}