import 'package:eni_l10n/src/provider/localization_provider.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:eni_svc/collection.dart';
import 'package:eni_utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Core localization interface that handles string translation and formatting.
class LocalizationInterface {
  final Map<String, dynamic> values;

  LocalizationInterface._(this.values);

  /// Translates a key using optional named or positional arguments.
  /// Supports aliasing via '@:key' notation.
  String translate(
    String string, {
    Map<String, dynamic>? namedArgs,
    List<dynamic>? args,
    BuildContext? context,
    String? gender,
  }) {
    // TODO: We don't really do anything with context or gender yet.

    final translated = values[string]?.toString();
    if (translated == null) {
      /// Recursive translation if value is alias
      return string;
    }

    if (translated.startsWith("@:")) {
      return translate(
        translated.substring(2),
        namedArgs: namedArgs,
        args: args,
        context: context,
        gender: gender,
      );
    }

    return _format(translated, namedArgs: namedArgs, args: args);
  }

  /// Matches variables like `{name}` or `{0}`
  static final _variablePattern = RegExp(r'\{\s*([^\}\s]+)?\s*\}');

  /// Replaces variables in the string with arguments
  String _format(
    String string, {
    Map<String, dynamic>? namedArgs,
    List<dynamic>? args,
  }) {
    int offset = 0;
    int nextArgIndex = 0;
    String result = "";
    for (final match in _variablePattern.allMatches(string)) {
      final nextOffset = match.end;
      if (offset < match.start) {
        result += string.substring(offset, match.start);
      }

      late final dynamic rawReplacement;
      final name = match.group(1);
      final argIndex = name != null ? int.tryParse(name) : nextArgIndex++;

      if (argIndex == null) {
        /// This is a named argument
        rawReplacement = namedArgs?[name] ?? "";
      } else {
        /// This is an unnamed argument
        rawReplacement = args?[argIndex] ?? "";
      }

      result += rawReplacement.toString();

      offset = nextOffset;
    }

    if (offset < string.length) {
      result += string.substring(offset);
    }

    return result;
  }

  static LocalizationInterface _singleton = LocalizationInterface._(const {});

  /// Current globally active instance
  static LocalizationInterface get current => _singleton;
}

/// Custom delegate that integrates into Flutter's localization system.
class _LocalizationsDelegate
    implements LocalizationsDelegate<LocalizationInterface> {
  final LocalizationProvider provider;

  _LocalizationsDelegate(List<LocalizationProvider> providers)
      : provider = LocalizationMultiProvider(providers: providers);

  @override
  bool isSupported(Locale locale) {
    return provider.isSupported(locale);
  }

  @override
  Future<LocalizationInterface> load(Locale locale) async {
    /// Load and flatten translations for the given locale
    final values = (await provider.load(locale)).flatten((k1, k2) => "$k1.$k2");
    final interface = LocalizationInterface._(values);

    /// Replace the global singleton instance
    LocalizationInterface._singleton = interface;
    _reloadRequested = false;
    return interface;
  }

  bool _reloadRequested = false;

  @override
  bool shouldReload(_LocalizationsDelegate old) {
    return _reloadRequested;
  }

  @override
  Type get type => LocalizationInterface;
}

/// Service that manages the currently active localization providers and delegates.
class LocalizationService with Service {
  final logger = loggerFor("LocalizationService");

  /// All localization delegates including the default Material ones
  List<LocalizationsDelegate> get delegates => [
        if (_delegate != null) _delegate!,
        ...GlobalMaterialLocalizations.delegates,
      ];

  _LocalizationsDelegate? _delegate;

  static final descriptor = ServiceDescriptor.from(
    create: (_) => LocalizationService(),
    name: 'LocalizationService',
    priority: -9000,
  );

  static LocalizationService of(BuildContext context) =>
      context.localizationService;

  @override
  Future onStart(ServiceRegistry services) async => _reloadProviders();

  @override
  Future onReload() async {
    // Todo: Maybe we should debounce this call.
    /// Trigger reload on hot restart or config changes
    _delegate?._reloadRequested = true;
    logger.i("Reloading localizations...");
  }

  void _reloadProviders() {
    /// Collect all registered localization providers
    final providers = services
        .getServices<LocalizationProvider>(
          requiredRunLevel: RunLevel.preInitialized,
        )
        .toList();
    logger.t("Found ${providers.length} localization provider(s)");
    _delegate = _LocalizationsDelegate(providers);
  }
}

/// Extension methods for convenient access to localization in a widget tree.
extension BuildContextLocalizationsServiceExtension on BuildContext {
  /// Get access to the registered localization service.
  LocalizationService get localizationService =>
      getService<LocalizationService>();

  /// Get the current localization interface (for translations).
  LocalizationInterface get l10n =>
      Localizations.of(this, LocalizationInterface);

  /// Get the current locale.
  Locale get locale => Localizations.localeOf(this);
}
