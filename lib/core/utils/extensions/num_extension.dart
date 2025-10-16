import 'package:flutter/cupertino.dart';

extension NumExtension on num {
  SizedBox get horizontalSpace => SizedBox(width: double.parse(toString()));
  SizedBox get verticalSpace => SizedBox(height: double.parse(toString()));

  String padLeft(int width, [String padding = ' ']) =>
      toString().padLeft(width, padding);

  /// Return a double with the given number of [fractionDigits].
  double toPrecision(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  /// Return a double with 2 [fractionDigits].
  double toPrecision2() => toPrecision(2);

  /// Returns the ordinal suffix of the number.
  /// Example: 1st, 2nd, 3rd, 4th, 5th, etc.
  String get _ordinalSuffix {
    if (this >= 11 && this <= 13) {
      return 'th';
    }
    return switch (this % 10) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
  }

  /// Returns the number with the ordinal suffix.
  /// Example: 1st, 2nd, 3rd, 4th, 5th, etc.
  String get withOrdinalSuffix => '$this$_ordinalSuffix';
}
