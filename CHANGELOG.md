## [5.0.1] (Apr 7, 2026)
- Added dot-notation shorthand for nested keys: `context.translate('nav.home')` resolves `{ "nav": { "home": "..." } }` automatically
- `translate()` now has safe error handling — falls back to returning the key instead of throwing
- Dot-notation only applies when no explicit `parent` list is provided
- Completely rewritten README with full API reference, correct examples, parameter tables, and interpolation/plurals guides
- Improved example project: showcases all features (simple keys, nested keys, interpolation, plurals, `TextIntl`, `NumberFormat`, `DateFormat`, runtime injection) with live language switching

## [4.1.0] (Feb 26, 2025)
- Added `TextIntl`
- Removed `translationContext`
- Added `parent` (fullpath to translation key)

## [4.0.1] (May 26, 2023)
- Updagrate flutter 3.10.2

## [4.0.0] (Jan 21, 2022)
- Removing codegen
- Added translation to BuildContext
- Added translation context

## [3.1.0] (May 10, 2021)
- Flutter 2

## [3.0.0] (June 11, 2020)
- New Features
    - Removed BuildContext need
    - Multi-files for location
    - Configuration via pubspac.yaml
    - Extension functions to traslate
    - Codegen for translations
    - Number format
    - Date format

- Removed Features
    - Default locate

## [2.0.0] (October 1, 2019)
- Configurations via yaml file

## [1.2.0] (Agust 16, 2019)
- Removed need to pass country code

## [1.1.0+1] (Agust 16, 2019)
- README example for named interpolation

## [1.1.0] (Agust 16, 2019)
- Added suport for named interpolation

## [1.0.1] (Agust 6, 2019)
- Null safety for locales

## [1.0.0+1] (July 27, 2019)
- Refactor code

## [1.0.0] (July 25, 2019)
- Initial release