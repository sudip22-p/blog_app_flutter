import 'package:blog_app/common/themes/typography/font_weight.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static const double baseFontSize = 14;

  static const _baseTextStyle = TextStyle(
    fontWeight: AppFontWeight.regular,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
    fontSize: baseFontSize,
  );

  // Display
  static final displayLarge = _baseTextStyle.copyWith(
    fontSize: 56.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 64.sp / 56.sp,
  );

  static final displayMedium = _baseTextStyle.copyWith(
    fontSize: 48.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 56.sp / 48.sp,
  );

  static final displaySmall = _baseTextStyle.copyWith(
    fontSize: 40.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 48.sp / 40.sp,
  );

  // Headline
  static final headlineLarge = _baseTextStyle.copyWith(
    fontSize: 32.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 40.sp / 32.sp,
  );

  static final headlineMedium = _baseTextStyle.copyWith(
    fontSize: 28.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 36.sp / 28.sp,
  );

  static final headlineSmall = _baseTextStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 32.sp / 24.sp,
  );

  // Title
  static final titleLarge = _baseTextStyle.copyWith(
    fontSize: 22.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 28.sp / 22.sp,
  );

  static final titleMedium = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 26.sp / 20.sp,
  );

  static final titleSmall = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    fontWeight: AppFontWeight.semiBold,
    height: 24.sp / 18.sp,
  );

  // Body
  static final bodyLarge = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    fontWeight: AppFontWeight.regular,
    height: 24.sp / 18.sp,
  );

  static final bodyMedium = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: AppFontWeight.regular,
    height: 24.sp / 16.sp,
  );

  static final bodySmall = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: AppFontWeight.regular,
    height: 20.sp / 14.sp,
  );

  // Button
  static final button = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: AppFontWeight.medium,
    height: 20.sp / 14.sp,
  );

  // Caption
  static final caption = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: AppFontWeight.regular,
    height: 16.sp / 12.sp,
  );

  // Underline
  static final underline = _baseTextStyle.copyWith(
    fontSize: 10.sp,
    fontWeight: AppFontWeight.regular,
    height: 14.sp / 10.sp,
    decoration: TextDecoration.underline,
  );
}
