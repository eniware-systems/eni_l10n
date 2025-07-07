import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'string_extension.dart';

enum DateTimeFormat {
  date,
  dateTime,
}

extension LocalizationDateTimeExtension on DateTime {
  String tr(
      {DateTimeFormat format = DateTimeFormat.dateTime,
      BuildContext? context}) {
    late final String key;
    const baseKey = "date-format";

    switch (format) {
      case DateTimeFormat.date:
        key = "$baseKey.date";
        break;
      case DateTimeFormat.dateTime:
        key = "$baseKey.datetime";
        break;
    }

    return DateFormat(key.tr(context: context)).format(this);
  }
}
