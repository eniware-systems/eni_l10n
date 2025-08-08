import 'dart:convert';
import 'dart:ui';

import 'package:eni_utils/logger.dart';

import 'asset_localization_provider.dart';

/// A localization provider that loads translation data from JSON files.
/// The file must be named according to the language code (e.g. `en.json`).
///
/// Creates a new JSON localization provider.
///
/// The [assetRoot] parameter is passed to the [basePath] parameter of the parent class.
/// It specifies the base directory where JSON localization files are stored.
class JsonLocalizationProvider extends AssetLocalizationProvider {
  JsonLocalizationProvider(super.assetRoot, {super.assetBundle});

  final _logger = loggerFor("JsonLocalizationProvider");

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    late final String json;

    try {
      /// Attempt to load the JSON file for the given locale.
      json = await loadStringAsset("${locale.languageCode.toLowerCase()}.json");
    } catch (e) {
      /// If the file is missing or unreadable, log the error and return an empty map.
      _logger.t(e);
      return {};
    }

    /// Decode the loaded JSON string into a Map.
    return jsonDecode(json);
  }
}
