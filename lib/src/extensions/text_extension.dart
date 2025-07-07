import 'package:flutter/widgets.dart';

import '../svc/localization_service.dart';

extension LocalizationTextExtension on Text {
  Text tr(
          {Map<String, dynamic>? namedArgs,
          List<dynamic>? args,
          String? gender,
          BuildContext? context}) =>
      Text(
        LocalizationInterface.current.translate(data ?? "",
            namedArgs: namedArgs, args: args, gender: gender, context: context),
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
