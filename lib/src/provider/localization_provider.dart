import 'package:eni_utils/collection.dart';
import 'package:flutter/widgets.dart';

abstract class LocalizationProvider {
  static const int defaultPriority = 0;

  bool isSupported(Locale locale);

  Future<Map<String, dynamic>> load(Locale locale);

  int get priority => defaultPriority;
}

class LocalizationMultiProvider extends LocalizationProvider {
  final List<LocalizationProvider> providers;

  LocalizationMultiProvider({required this.providers}) {
    providers.sort((a, b) => a.priority.compareTo(b.priority));
  }

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    final results = <String, dynamic>{};
    for (final p in providers.where((p) => p.isSupported(locale))) {
      results.merge(await p.load(locale));
    }
    return results;
  }

  @override
  bool isSupported(Locale locale) {
    return providers.any((p) => p.isSupported(locale));
  }
}
