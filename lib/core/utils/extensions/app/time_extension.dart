import 'package:flutter/material.dart' show TimeOfDay;

extension TimeOfDayX on TimeOfDay {
  int get inMinutes => hour * 60 + minute;

  /// Returns the difference between two [TimeOfDay]s in minutes.
  int diff(TimeOfDay time) {
    final thisInMinutes = inMinutes;
    final timeInMinutes = time.inMinutes;

    if (thisInMinutes > timeInMinutes) {
      return thisInMinutes - timeInMinutes;
    } else {
      return timeInMinutes - thisInMinutes;
    }
  }

  /// Returns the formatted time in 12-hour format.
  String get format24 => '$hour:$minute';

  static TimeOfDay parse(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static TimeOfDay? tryParse(String time) {
    try {
      return parse(time);
    } catch (_) {
      return null;
    }
  }
}
