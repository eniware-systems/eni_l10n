import 'dart:convert';
import 'dart:ui';

import 'package:eni_utils/logger.dart';

import 'asset_localization_provider.dart';

class JsonLocalizationProvider extends AssetLocalizationProvider {
  JsonLocalizationProvider(super.assetRoot, {super.assetBundle});

  final _logger = loggerFor("JsonLocalizationProvider");

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    late final String json;

    try {
      json = await loadStringAsset("${locale.languageCode.toLowerCase()}.json");
    } catch (e) {
      // File was not found.
      _logger.t(e);
      return {};
    }

    return jsonDecode(json);
  }
}
