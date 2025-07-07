import 'package:eni_l10n/src/provider/localization_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class AssetLocalizationProvider extends LocalizationProvider {
  final AssetBundle assetBundle;
  final String basePath;

  AssetLocalizationProvider(this.basePath, {AssetBundle? assetBundle})
      : assetBundle = assetBundle ?? rootBundle;

  @override
  bool isSupported(Locale locale) {
    // We have no real way of knowing whether a requested asset really exists
    // until it is loaded, so we just assume true here.
    return true;
  }

  @protected
  String getAssetPath(String path) => "$basePath/$path";

  @protected
  Future<String> loadStringAsset(String path) {
    return assetBundle.loadString(getAssetPath(path));
  }
}
