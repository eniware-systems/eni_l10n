import 'package:eni_l10n/src/provider/localization_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Base class for asset-based localization providers (e.g. JSON, YAML).
/// It loads files from the Flutter asset bundle given a base path.
abstract class AssetLocalizationProvider extends LocalizationProvider {
  final AssetBundle assetBundle;
  final String basePath;

  /// Constructor with optional custom AssetBundle (useful for testing).
  /// Falls back to the default `rootBundle`.
  AssetLocalizationProvider(this.basePath, {AssetBundle? assetBundle})
      : assetBundle = assetBundle ?? rootBundle;

  @override
  bool isSupported(Locale locale) {
    /// We have no real way of knowing whether a requested asset really exists
    /// until it is loaded, so we just assume true here.
    return true;
  }

  /// Constructs the full asset path using the base path and the given file name.
  @protected
  String getAssetPath(String path) => "$basePath/$path";

  /// Loads the content of a text file from assets.
  @protected
  Future<String> loadStringAsset(String path) {
    return assetBundle.loadString(getAssetPath(path));
  }
}
