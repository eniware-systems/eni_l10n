import 'package:flutter/widgets.dart';

import '../svc/localization_service.dart';

/// Extension method on `Text` widget to automatically localize its content.
/// Keeps all other properties of the `Text` widget unchanged.
/// Example: `Text("hello").tr()` will display the localized version of "hello".
extension LocalizationTextExtension on Text {
  Text tr({
    Map<String, dynamic>? namedArgs,
    List<dynamic>? args,
    String? gender,
    BuildContext? context,
  }) =>
      Text(
        LocalizationInterface.current.translate(
          data ?? "",
          namedArgs: namedArgs,
          args: args,
          gender: gender,
          context: context,
        ),

        /// Preserve all existing properties of the original Text widget
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}
