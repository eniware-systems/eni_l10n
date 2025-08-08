# eni_l10n - Eniware l10n Localization

This package builds on top of the standard Flutter package [easy_localization](https://pub.dev/packages/easy_localization), extending it with a flexible provider architecture. It supports multiple file formats (JSON, YAML), multi-source localization, and convenient translation extensions — all with hot reload support.

## Features

- **Customizable Providers** — Load localization data from JSON or YAML files in your asset bundle.
- **Multi-provider Support** — Combine multiple localization sources using priority-based merging.
- **Convenient Extensions** — `.tr()` translation extensions for `String`, `Text`, and `DateTime`.
- **Hot Reload Support** — Changes to localization files are reflected instantly during development.

---

## Getting Started


To begin using `eni_l10n` in your project, simply install the package via:

```bash
dart pub add eni_l10n
```

## Usage

### 1. Add Your Asset Files

Place your translation files in the asset directory (e.g., `assets/l10n/`):

```yaml
assets/l10n/en.json
assets/l10n/de.yaml
```

Enable them in your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/l10n/
```

### 2. Create a Localization Provider

Choose between JSON and YAML formats:

```json
final provider = JsonLocalizationProvider("assets/l10n");
```

Or for YAML:

```yaml
final provider = YamlLocalizationProvider("assets/i18n");
```

You can also combine multiple providers:

```dart
final provider = LocalizationMultiProvider(
  providers: [
    JsonLocalizationProvider("assets/l10n/json"),
    YamlLocalizationProvider("assets/l10n/yaml"),
  ],
);
```

### 3. Load Translations

Each provider implements LocalizationProvider, which can load translations for a given Locale:

```dart
final Map<String, dynamic> localizedValues = await provider.load(Locale('en'));
```

## Translation Extensions
###  Text Widget Extension

Use `.tr()` on a `Text` widget

```dart
Text("hello_world").tr();
```

#### String Extension

Use .tr() on any String:

```dart
"greeting".tr(namedArgs: {"name": "Alice"});
```

#### DateTime Extension

Format DateTime objects with localized date or datetime format keys:

```dart
DateTime.now().tr(format: DateTimeFormat.date);
```

Expected keys in your translations:

```yaml
date-format:
  date: yyyy-MM-dd
  datetime: yyyy-MM-dd HH:mm
```

## How It Works

### `LocalizationProvider`

The base interface for any localization provider:

```dart
abstract class LocalizationProvider {
  bool isSupported(Locale locale);
  Future<Map<String, dynamic>> load(Locale locale);
  int get priority => 0;
}
```

### `AssetLocalizationProvider`

A base class for loading files from assets.

### `JsonLocalizationProvider / YamlLocalizationProvider`

Concrete implementations that load translations from `.json` or `.yaml` files respectively. If the file doesn't exist, they log the error and return an empty map.

### `LocalizationMultiProvider`

Combines multiple providers and merges their results based on their priority.

### Notes

  - **File names must match the language code**, e.g. en.json, de.yaml.

  - **Nested structures** in YAML/JSON are supported and converted into flat key-value pairs (e.g. `"greetings.hello": "Hello!"`).

  - You can inject a custom AssetBundle (e.g., for testing).

### Integration with easy_localization

This package is fully compatible with [easy_localization](https://pub.dev/packages/easy_localization). You can use `eni_l10n` as a drop-in replacement or to extend its functionality by injecting a custom `LocalizationProvider`.

## License
This project is licensed under the MIT License.

Copyright © 2025 Eniware Systems GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.