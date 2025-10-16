import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

class CustomSnackbar {
  static Future<bool?> cancelToastMessage() {
    return Fluttertoast.cancel();
  }

  static Future<bool?>? showToastMessage({
    required ToastType type,
    required String message,
    Toast? toastLength,
    int timeInSecForIosWeb = 2,
    double fontSize = 14,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
  }) async {
    // Default styles based on type
    backgroundColor ??= _getBackgroundColor(type);
    textColor ??= Colors.white;
    await Fluttertoast.cancel();
    return await Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green[600]!;
      case ToastType.error:
        return Colors.red[600]!;
      case ToastType.info:
        return Colors.orange[700]!;
    }
  }
}
