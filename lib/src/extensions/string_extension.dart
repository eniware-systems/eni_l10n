import 'package:flutter/widgets.dart';

import '../svc/localization_service.dart';

extension LocalizationStringExtension on String {
  String tr(
          {Map<String, dynamic>? namedArgs,
          List<dynamic>? args,
          String? gender,
          BuildContext? context}) =>
      LocalizationInterface.current.translate(this,
          namedArgs: namedArgs, args: args, gender: gender, context: context);
}
