import 'package:eni_svc/collection.dart';
import 'package:eni_utils/eni_utils.dart';
import 'package:flutter/widgets.dart';

/// Interface for all localization providers.
/// Implementations must support loading translations and declaring support for a locale.
abstract class LocalizationProvider {
  static const int defaultPriority = 0;

  /// Determines if the given locale is supported by this provider.
  bool isSupported(Locale locale);

  /// Loads the translation map for the given locale.
  Future<Map<String, dynamic>> load(Locale locale);

  /// Optional priority for merging multiple providers (lower = higher priority).
  int get priority => defaultPriority;
}

/// Combines multiple localization providers and merges their results.
/// Providers are sorted by priority; lower numbers override higher ones.
class LocalizationMultiProvider extends LocalizationProvider {
  final List<LocalizationProvider> providers;

  /// Constructor that accepts a list of providers and sorts them by priority.
  LocalizationMultiProvider({required this.providers}) {
    providers.sort((a, b) => a.priority.compareTo(b.priority));
  }

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    final results = <String, dynamic>{};

    /// Iterate over supported providers and merge their results.
    for (final p in providers.where((p) => p.isSupported(locale))) {
      try {
        results.merge(await p.load(locale));
      } catch (e) {
        loggerFor("LocalizationMultiProvider").e("Failed to load locales: $e");
      }
    }
    return results;
  }

  @override
  bool isSupported(Locale locale) {
    /// At least one provider must support the given locale.
    return providers.any((p) => p.isSupported(locale));
  }
}
