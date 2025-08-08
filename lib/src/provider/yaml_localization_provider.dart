import 'dart:ui';

import 'package:eni_utils/eni_utils.dart';
import 'package:yaml/yaml.dart';

import 'asset_localization_provider.dart';

/// Converts a YAML map into a standard Dart map.
/// Nested structures are flattened recursively.
Map<String, dynamic> _fromYaml(YamlMap yaml) {
  final result = <String, dynamic>{};
  for (final node in yaml.entries) {
    final key = node.key.toString();
    late final dynamic value;

    // Recursively process nested maps
    if (node.value is YamlMap) {
      value = _fromYaml(node.value);
    } else {
      value = node.value.toString();
    }
    result[key] = value;
  }
  return result;
}

/// A localization provider that loads translation data from YAML files.
/// The file must be named according to the language code (e.g. `en.yaml`).
///
/// Creates a new YAML localization provider.
///
/// The [assetRoot] parameter is passed to the [basePath] parameter of the parent class.
/// It specifies the base directory where YAML localization files are stored.
class YamlLocalizationProvider extends AssetLocalizationProvider {
  YamlLocalizationProvider(super.assetRoot, {super.assetBundle});

  final _logger = loggerFor("YamlLocalizationProvider");

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    late final String src;

    try {
      /// Attempt to load the YAML file for the given locale.
      src = await loadStringAsset("${locale.languageCode.toLowerCase()}.yaml");
    } catch (e) {
      /// If the file is missing or unreadable, log the error and return an empty map.
      _logger.t(e);
      return {};
    }

    /// Parse the YAML content into a YamlMap.
    final YamlMap yaml = loadYaml(src);

    /// Convert the YamlMap to a standard Dart Map.
    return _fromYaml(yaml);
  }
}
