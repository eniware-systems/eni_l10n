import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'string_extension.dart';

/// Defines which date format should be used when translating a DateTime.
/// - `date`: short date only
/// - `dateTime`: full date and time
enum DateTimeFormat { date, dateTime }

/// Extension method on `DateTime` to get a localized formatted string.
/// The formatting key is expected in your localization file (e.g., "date-format.date").
extension LocalizationDateTimeExtension on DateTime {
  String tr({
    DateTimeFormat format = DateTimeFormat.dateTime,
    BuildContext? context,
  }) {
    late final String key;
    const baseKey = "date-format";

    /// Choose the translation key based on the selected format
    switch (format) {
      case DateTimeFormat.date:
        key = "$baseKey.date";
        break;
      case DateTimeFormat.dateTime:
        key = "$baseKey.datetime";
        break;
    }

    /// Use the translated format string to format the date
    return DateFormat(key.tr(context: context)).format(this);
  }
}
