import 'package:intl/intl.dart';
import 'package:blog_app/core/core.dart';

extension DateTimeExtensions on DateTime {
  /// Returns the date in `YYYY-MM-DD` format.
  String get formattedDate => DateFormat('yyyy-MM-dd').format(this);

  /// Returns the time in `HH:mm:ss` format.
  String get formattedTime => DateFormat('HH:mm:ss').format(this);
  String get formattedTimeWithoutSecond => DateFormat('HH:mm').format(this);

  /// Returns the time in `hh:mm a` format (12-hour clock).
  String get formattedTime12Hour => DateFormat('hh:mm a').format(this);

  /// Returns the time in `hh:mm` format (12-hour clock).
  String get formattedTimeWithoutSuffix12Hour =>
      DateFormat('hh:mm').format(this);

  /// Returns a human-friendly date format like `Feb 04, 2025`
  String get friendlyDate => DateFormat('MMM dd, yyyy').format(this);
  String friendlyDateTime(String? locale) =>
      DateFormat('MMM dd, yyyy, hh:mm a', locale).format(this);

  /// Returns a full formatted date and time `YYYY-MM-DD HH:mm:ss`
  String get formattedDateTime =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  /// Returns a formatted string like "15 August 2025 | 11:00 AM"
  String get fullDateWithTime =>
      DateFormat('d MMMM yyyy | hh:mm a').format(this);
}

extension DateTimeStringExtensions on String {
  DateTime? get parseDate {
    // Attempt to parse the date string to a DateTime object
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(this);
    } catch (_) {}
    return parsedDate;
  }

  String get friendlyDate =>
      (parseDate ?? DateTime.now()).toLocal().friendlyDate;
}

extension DateTimeIntExtensions on int {
  DateTime? get parseDate {
    // Attempt to parse the date string to a DateTime object
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    } catch (_) {}
    return parsedDate;
  }

  String get friendlyDate =>
      (parseDate ?? DateTime.now()).toLocal().fullDateWithTime;
}
