import 'dart:ui';

import 'package:eni_utils/eni_utils.dart';
import 'package:yaml/yaml.dart';

import 'asset_localization_provider.dart';

Map<String, dynamic> _fromYaml(YamlMap yaml) {
  final result = <String, dynamic>{};
  for (final node in yaml.entries) {
    final key = node.key.toString();
    late final dynamic value;

    if (node.value is YamlMap) {
      value = _fromYaml(node.value);
    } else {
      value = node.value.toString();
    }
    result[key] = value;
  }
  return result;
}

class YamlLocalizationProvider extends AssetLocalizationProvider {
  YamlLocalizationProvider(super.assetRoot, {super.assetBundle});

  final _logger = loggerFor("YamlLocalizationProvider");

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    late final String src;

    try {
      src = await loadStringAsset("${locale.languageCode.toLowerCase()}.yaml");
    } catch (e) {
      // File was not found.
      _logger.t(e);
      return {};
    }

    final YamlMap yaml = loadYaml(src);
    return _fromYaml(yaml);
  }
}
