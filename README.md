# eni_l10n - Eniware l10n Localization

This package builds on top of the standard Flutter
package [easy_localization](https://pub.dev/packages/easy_localization), extending it with a flexible provider
architecture. It supports multiple file formats (JSON, YAML), multi-source localization, and convenient translation
extensions — all with hot reload support.

## Features

- **Customizable Providers** — Load localization data from JSON or YAML files in your asset bundle.
- **Multi-provider Support** — Combine multiple localization sources using priority-based merging.
- **Convenient Extensions** — `.tr()` translation extensions for `String`, `Text`, and `DateTime`.
- **Hot Reload Support** — Changes to localization files are reflected instantly during development.
- **Works seamlessly with [easy_localization](https://pub.dev/packages/easy_localization)**.

---

## Getting Started

To begin using `eni_l10n` in your project, simply install the package via:

### 1. Install

```bash
dart pub add eni_l10n
```

### 2. Add translation files

**assets/l10n/en.yaml**

```yaml
app:
  title: "Localization Example"
greeting: "Hello, {name}!"
switch:
  language: "Switch to German"
```

**assets/l10n/de.yaml**

```yaml
app:
  title: "Lokalisierungsbeispiel"
greeting: "Hallo, {name}!"
switch:
  language: "Wechsel zu Englisch"
```

Nested YAML/JSON structures are automatically flattened (e.g. `app.title`).
File names must match language codes (`en.yaml`, `de.json`).

Update your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/l10n/
```

### Setup Translation

```dart
import 'package:flutter/material.dart';
import 'package:eni_l10n/eni_l10n.dart';
import 'package:eni_svc/eni_svc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ServiceScope(
      child: const MyApp(),
    )
      ..addL10n()
      ..addPackage(
        makePackage("app")
          ..useL10n(
            path: "assets/l10n",
            useJson: false,
            useYaml: true,
          ),
      ),
  );
}
```

### Select Translation

The active locale is given to the `MaterialApp`:

```dart
class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _switchLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('de')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(_locale.toString()),
      locale: _locale,
      localizationsDelegates: context.localizationService.delegates,
      supportedLocales: const [Locale('en'), Locale('de')],
      home: HomePage(onSwitch: _switchLocale),
    );
  }
}
```

Make sure all your wanted locales are give to the parameter `supportedLocales`.

### Using Translation

Now the selected locale is used by the `String` extension method `tr()`:

```dart
class HomePage extends StatelessWidget {
  final VoidCallback onSwitch;

  const HomePage({super.key, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app.title".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "greeting".tr(namedArgs: {"name": "Maria"}),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSwitch,
              child: Text("switch.language".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
```

Each string followed by `.tr()` is interpreted as path to the actual text inside the
yaml file of the selected locale.
---

## Date handling

The `DateTime` extension method `tr` translates a given date or time
to the format given by the current yaml of the selected locale.

```dart

final formatted = DateTime.now().tr(format: DateTimeFormat.date);
```

To use the `DateTime` extension
each locale yaml needs the following keys for the date and time format:

```yaml
date-format:
  date: yyyy-MM-dd
  datetime: yyyy-MM-dd HH:mm
```

---

## Providers

```dart
abstract class LocalizationProvider {
  bool isSupported(Locale locale);
  Future<Map<String, dynamic>> load(Locale locale);
  int get priority => 0;
}
```

- **JsonLocalizationProvider / YamlLocalizationProvider** - load from assets
- **LocalizationMultiProvider** - merge multiple providers
- **Custom Providers** - implement your own (REST API, DB, etc.)

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

Concrete implementations that load translations from `.json` or `.yaml` files respectively. If the file doesn't exist,
they log the error and return an empty map.

### `LocalizationMultiProvider`

Combines multiple providers and merges their results based on their priority.

### Notes

- You can inject a custom AssetBundle (e.g., for testing).
- This package is fully compatible with [easy_localization](https://pub.dev/packages/easy_localization). You can use
  `eni_l10n` as a drop-in replacement or to extend its functionality by injecting a custom `LocalizationProvider`.

## License

This project is licensed under the MIT License.

Copyright © 2025 Eniware Systems GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the “Software”), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.