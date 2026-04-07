# internationalization

A Flutter package that makes adding multi-language support to your app simple and flexible — no code generation required.

[![pub.dev](https://img.shields.io/pub/v/internationalization.svg)](https://pub.dev/packages/internationalization)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Features

- ✅ Load translations from **local JSON asset files**
- ✅ **Inject translations at runtime** from any external source (API, database, etc.)
- ✅ **Nested keys** — navigate deep JSON structures with `parent` or dot notation
- ✅ **String interpolation** with positional (`{0}`, `{1}`) and named (`::key::`) arguments
- ✅ **Plural support** — `zero`, `one`, `other` forms
- ✅ Extension methods on `String` and `BuildContext` for ergonomic usage
- ✅ **`TextIntl` widget** — a drop-in replacement for `Text` that auto-translates
- ✅ Re-exports `NumberFormat` and `DateFormat` from the `intl` package

---

## Installation

```yaml
dependencies:
  internationalization: ^5.0.1
  flutter_localizations:
    sdk: flutter
```

---

## Setup

### 1. Asset files

Create one JSON file per language inside your assets folder. The default path is `assets/translations/`. Files must be named after the language code (e.g. `en.json`, `pt.json`).

```
assets/
└── translations/
    ├── en.json
    ├── pt.json
    └── es.json
```

Register the folder in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/translations/en.json
    - assets/translations/pt.json
    - assets/translations/es.json
```

> **Note:** If your translations span multiple files per locale, list every file individually or use a directory entry (e.g. `assets/translations/en/`). The path must match exactly what you pass to `translationsPath`.

---

### 2. MaterialApp configuration

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

const _supportedLocales = [
  Locale('en'),
  Locale('pt'),
  Locale('es'),
];

MaterialApp(
  supportedLocales: _supportedLocales,
  localizationsDelegates: [
    InternationalizationDelegate(
      suportedLocales: _supportedLocales,
      // Default path is 'assets/translations/' — only override if needed.
      translationsPath: 'assets/translations/',
      // Optional: merge translations fetched at runtime (API, remote config, etc.)
      addTranslations: (locale) async {
        return {
          'remote_key': 'Value from the network for ${locale.languageCode}',
        };
      },
    ),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
);
```

#### `InternationalizationDelegate` parameters

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `suportedLocales` | `List<Locale>` | ✅ | — | Locales the app supports |
| `translationsPath` | `String` | | `'assets/translations/'` | Path to the JSON files directory |
| `addTranslations` | `Future<Map<String, dynamic>> Function(Locale)?` | | `null` | Callback to inject extra translations at load time |

---

## JSON structure

Translations are plain JSON objects. Keys can be flat or deeply nested:

```json
{
  "greeting": "Hello, World!",
  "nav": {
    "home": "Home",
    "settings": "Settings"
  },
  "user": {
    "profile": {
      "title": "My Profile"
    }
  }
}
```

---

## Translate

### Context extension

```dart
// Flat key
context.translate('greeting');

// Nested key — dot notation (shorthand)
context.translate('nav.home');

// Nested key — explicit parent list
context.translate('title', parent: ['user', 'profile']);
```

### String extension

```dart
'greeting'.translate(context);

'nav.home'.translate(context);
```

### `TextIntl` widget

A drop-in replacement for `Text` that translates its key automatically:

```dart
TextIntl('greeting')

TextIntl(
  'nav.home',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)
```

`TextIntl` accepts all the same parameters as `Text` (style, textAlign, overflow, maxLines, etc.) plus the translation parameters `parent`, `args`, `namedArgs`, and `pluralValue`.

---

## Interpolation

### Positional arguments — `{0}`, `{1}`, …

JSON:
```json
{
  "welcome_message": "Hello, {0}! You have {1} new messages."
}
```

Dart:
```dart
context.translate(
  'welcome_message',
  args: ['Alice', '5'],
);
// → "Hello, Alice! You have 5 new messages."
```

### Named arguments — `::key::`

JSON:
```json
{
  "welcome_back": "Welcome back, ::firstName:: ::lastName::!"
}
```

Dart:
```dart
context.translate(
  'welcome_back',
  namedArgs: {'firstName': 'John', 'lastName': 'Doe'},
);
// → "Welcome back, John Doe!"
```

### Combined positional + named

JSON:
```json
{
  "order_ready": "Dear ::name::, your order #{0} is ready."
}
```

Dart:
```dart
context.translate(
  'order_ready',
  args: ['42'],
  namedArgs: {'name': 'Maria'},
);
// → "Dear Maria, your order #42 is ready."
```

---

## Plurals

Define a `zero`, `one`, and `other` form for any key:

JSON:
```json
{
  "cart": {
    "items": {
      "zero": "Your cart is empty.",
      "one": "You have {0} item in your cart.",
      "other": "You have {0} items in your cart."
    }
  }
}
```

Dart:
```dart
// zero
context.translate('items', parent: ['cart'], pluralValue: 0, args: ['0']);
// → "Your cart is empty."

// one
context.translate('items', parent: ['cart'], pluralValue: 1, args: ['1']);
// → "You have 1 item in your cart."

// other
context.translate('items', parent: ['cart'], pluralValue: 42, args: ['42']);
// → "You have 42 items in your cart."
```

Plural forms can also be combined with named args:

```dart
context.translate(
  'download_status',
  parent: ['files'],
  pluralValue: 1,
  namedArgs: {'file': 'report.pdf'},
);
```

---

## NumberFormat & DateFormat

`NumberFormat` and `DateFormat` are re-exported directly from the [`intl`](https://pub.dev/packages/intl) package — no extra import needed:

```dart
import 'package:internationalization/internationalization.dart';

// Currency
NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(1234.56);
// → "R$ 1.234,56"

// Compact
NumberFormat.compact().format(1200000);
// → "1.2M"

// Date
DateFormat.yMMMMd('en').format(DateTime.now());
// → "April 7, 2026"

DateFormat('EEEE, MMM d yyyy', 'pt').format(DateTime.now());
// → "segunda-feira, abr 7 2026"
```

See the full docs:
- [NumberFormat](https://pub.dev/packages/intl#number-formatting-and-parsing)
- [DateFormat](https://pub.dev/packages/intl#date-formatting-and-parsing)

---

## Runtime translation injection

Use `addTranslations` to merge extra keys when the delegate loads — useful for remote config, A/B testing, or server-driven copy:

```dart
InternationalizationDelegate(
  suportedLocales: _supportedLocales,
  addTranslations: (locale) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/strings/${locale.languageCode}'),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  },
),
```

Injected keys follow the same JSON structure and can be accessed with `context.translate`, the String extension, or `TextIntl` exactly like local keys.

---

## Example

A full showcase example demonstrating every feature is available in the [`example/`](example/) directory. It covers simple strings, nested keys, interpolation, plurals, runtime injection, and `NumberFormat`/`DateFormat` — with a live language switcher between English, Portuguese, and Spanish.

```bash
cd example
flutter run
```

---

## API reference

### `Translator`

| Method | Description |
|---|---|
| `Translator.of(context)` | Returns the `Translator` instance for the current locale |
| `translate(key, {parent, pluralValue, args, namedArgs})` | Core translation method |
| `addExternalTranslations(Map)` | Merge additional translations at runtime |

### `InternationalizationDelegate`

Flutter `LocalizationsDelegate<Translator>` — wire it into `localizationsDelegates`.

### Extensions

| Extension | Method | Description |
|---|---|---|
| `StringExtension` | `'key'.translate(context, {...})` | Translate from a String literal |
| `ContextTranslator` | `context.translate('key', {...})` | Translate using a BuildContext |
| `ContextTranslator` | `context.translator` | Access the raw `Translator` instance |

### `TextIntl`

A `StatelessWidget` wrapping `Text`. Accepts all `Text` parameters plus `parent`, `args`, `namedArgs`, and `pluralValue`.