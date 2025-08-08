import 'package:flutter/widgets.dart';

import '../svc/localization_service.dart';

/// Extension method on `String` to translate a key with optional arguments.
/// Supports named arguments, positional arguments, gender, and context-based resolution.
extension LocalizationStringExtension on String {
  String tr({
    Map<String, dynamic>? namedArgs,
    List<dynamic>? args,
    String? gender,
    BuildContext? context,
  }) =>
      LocalizationInterface.current.translate(
        this,
        namedArgs: namedArgs,
        args: args,
        gender: gender,
        context: context,
      );
}
