import 'package:eni_l10n/eni_l10n.dart';
import 'package:eni_l10n/src/provider/json_localization_provider.dart';
import 'package:eni_l10n/src/provider/yaml_localization_provider.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:eni_utils/eni_utils.dart';
import 'package:flutter/widgets.dart';

class LocalizationPackageFeature extends PackageFeature {
  static const defaultL10nPath = "assets/l10n";

  static const _configKeyBase = "l10n";
  static const configKeyYamlPath = "$_configKeyBase.yaml.path";
  static const configKeyJsonPath = "$_configKeyBase.json.path";

  @override
  String get name => "localization";

  final _logger = loggerFor("LocalizationPackageFeature");

  @override
  void onApply(Package package) {
    final yamlPath = package.getConfig(configKeyYamlPath, "");
    final jsonPath = package.getConfig(configKeyJsonPath, "");

    if (yamlPath.isEmpty && jsonPath.isEmpty) {
      // No provider has been selected, so we don't have l10n support in this package.
      return;
    }

    _logger.i("Installing l10n features for ${package.name}");

    if (yamlPath.isNotEmpty) {
      package.services.register(ServiceDescriptor.from<LocalizationProvider>(
          name: "${package.name}_YamlLocalizationProvider",
          create: (context) => YamlLocalizationProvider(
              "${package.rootPath}$yamlPath",
              assetBundle: DefaultAssetBundle.of(context))));
    }

    if (jsonPath.isNotEmpty) {
      package.services.register(ServiceDescriptor.from<LocalizationProvider>(
          name: "${package.name}_JsonLocalizationProvider",
          create: (context) => JsonLocalizationProvider(
              "${package.rootPath}$jsonPath",
              assetBundle: DefaultAssetBundle.of(context))));
    }
  }
}

class _LocalizationPackage extends Package {
  @override
  String get name => "eni_l10n";

  @override
  void onRegister(ServiceRegistry services) {
    services.register(LocalizationService.descriptor);
    services.addFeature(LocalizationPackageFeature());
    services.addConfiguration<_LocalizationPackage>({
      LocalizationPackageFeature.configKeyJsonPath:
          LocalizationPackageFeature.defaultL10nPath
    });
  }
}

extension PackageBuilderL10nExtension on PackageBuilder {
  void useL10n(
      {String path = LocalizationPackageFeature.defaultL10nPath,
      bool useYaml = true,
      bool useJson = true}) {
    if (useYaml) {
      withConfig(LocalizationPackageFeature.configKeyYamlPath, path);
    }

    if (useJson) {
      withConfig(LocalizationPackageFeature.configKeyJsonPath, path);
    }
  }
}

extension ServiceRegistryL10nExtension on MutableServiceRegistry {
  void addL10n() {
    final package = _LocalizationPackage();
    register(
        ServiceDescriptor.from(name: package.name, create: (_) => package));
  }
}
