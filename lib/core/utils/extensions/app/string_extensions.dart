import 'package:intl/intl.dart';

extension StringExt on String {
  /// first letter capitalize
  String capitalize() => trim().isEmpty
      ? ''
      : trim().substring(0, 1).toUpperCase() + trim().substring(1);

  /// covert date time to hours
  String toHourMinuteFormat(DateTime dateTime, {String format = 'hh:mma'}) {
    try {
      final dateFormat = DateFormat(format);
      return dateFormat.format(dateTime).toLowerCase();
    } catch (_) {
      return '';
    }
  }

  // replace underscores with spaces, capitalize words
  String get formatJsonKey => split(
    '_',
  ).map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');

  ///custom date format
  String formatDateTime(
    DateTime datetime, {
    String format = 'dd/MM/yyyy hh:mm a',
  }) => DateFormat(format).format(datetime);
}

extension NullabeStringExtension on String? {
  bool get isNullOrEmpty => (this == null || this!.isEmpty);

  String get defaultValueOnNull => isNullOrEmpty ? "--:--" : this!;
}
