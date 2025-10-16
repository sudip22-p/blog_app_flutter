import 'package:blog_app/core/utils/utils.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ScaffoldState get scaffold => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger =>
      ScaffoldMessenger.of(this)..hideCurrentSnackBar();

  void showErrorSnackBarMessage(String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.error,
        content: Text(message, style: TextStyle(color: colorScheme.onError)),
      ),
    );
  }

  void showSnackBarMessage(String message) =>
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
}

extension SizeContextExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ///Auto get device max screen size as width
  double get devicWidth => Device.width;

  ///Auto get device max screen size as height
  double get devicHeight => Device.height;
}

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  ColorScheme get colorScheme => theme.colorScheme;
  CustomThemeExtension get customTheme =>
      Theme.of(this).extension<CustomThemeExtension>()!;
}
