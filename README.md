# internationalization

A project to easily implement internationalization on flutter projects

## Configure Internationalization

Create a yaml file named `internationalization` then do the configurations like this:

``` yaml
path: ./assets/strings
default_locale:
  language: en
  country: US
locales:
  - locale:
      language: pt
  - locale:
      language: en
      country: US
```

- path -> where JSON files (strings) were placed
- default_locale -> default strings
- locales -> Array of locales

Now import internationalization package on main.dart.

``` dart
import 'package:internationalization/internationalization.dart';
```

Make `void main()` async then load internationalization configurations

``` dart
void main() async {
  await Internationalization.loadConfigurations();
  runApp(InternationalizationExampleApp());
}
```

Pass the delegates to `localizationsDelegates`.

``` dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: suportedLocales,
        localizationsDelegates: [
            Internationalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        ],
    );
}
```

In `pubspec.yaml` put the path that you've passed to `InternationalizationDelegate` and the configuration file

``` yaml
flutter:
  assets:
    - ./assets/strings/
    - ./internationalization.yaml
```

## Usage

``` dart
Strings.of(context).valueOf("key") //To get a simple string
Strings.of(context).valueOf("key", args: ["A", "B", "C"]) //To get a interpoled string
Strings.of(context).pluralOf("key", 0) //To get a plural string
Strings.of(context).pluralOf("key", 0, args: ["A", "B", "C"]) //To get a plural interpoled string
Strings.of(context).valueOf("key", args: ["A", "B", "C"], namedArgs: {"named_arg_key": "Named arg"}) //To get a interpoled name string
```

## JSON file

Crete JSON files with locale language code and country code. Ex.: `pt.json`, `en_US.json`, etc...
`Note: create JSON files inside folder you passed to InternationalizationDelegate`

``` json
{
    "simple_string": "Simple string value",
    "interpolation_string": "Interpoleted {0} string {1}",
    "simple_plurals" : {
        "zero": "No information",
        "one": "A item",
        "other": "Many itens"
    },
    "interpolation_plurals": {
        "zero": "No information {0} with {1}",
        "one": "A item {0} with {1}",
        "other": "Many itens {0} with {1}"
    },
    "interpolation_string_with_named_args": "Interpoleted {0} string with ::named_arg_key::"
}
```