//Theme configuration parameters that can be adjusted based on environment or user settings.
import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';

class ThemeConfigs {
  static ThemeData lightTheme() {
    return ThemeData(
      fontFamily: AppConstants.englishFont,
      extensions: const [CustomThemeExtension.lightMode],
      textTheme: TextTheme(
        displayLarge: AppTextStyle.displayLarge.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        displayMedium: AppTextStyle.displayMedium.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        displaySmall: AppTextStyle.displaySmall.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        headlineLarge: AppTextStyle.headlineLarge.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        headlineMedium: AppTextStyle.headlineMedium.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        headlineSmall: AppTextStyle.headlineSmall.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        titleLarge: AppTextStyle.titleLarge.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        titleMedium: AppTextStyle.titleMedium.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        titleSmall: AppTextStyle.titleSmall.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        bodyLarge: AppTextStyle.bodyLarge.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        bodyMedium: AppTextStyle.bodyMedium.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        bodySmall: AppTextStyle.bodySmall.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        labelLarge: AppTextStyle.button.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        labelMedium: AppTextStyle.caption.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
        labelSmall: AppTextStyle.underline.copyWith(
          color: CustomThemeExtension.lightMode.contentPrimary,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      fontFamily: AppConstants.englishFont,
      extensions: const [CustomThemeExtension.darkMode],
      textTheme: TextTheme(
        displayLarge: AppTextStyle.displayLarge.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        displayMedium: AppTextStyle.displayMedium.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        displaySmall: AppTextStyle.displaySmall.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        headlineLarge: AppTextStyle.headlineLarge.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        headlineMedium: AppTextStyle.headlineMedium.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        headlineSmall: AppTextStyle.headlineSmall.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        titleLarge: AppTextStyle.titleLarge.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        titleMedium: AppTextStyle.titleMedium.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        titleSmall: AppTextStyle.titleSmall.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        bodyLarge: AppTextStyle.bodyLarge.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        bodyMedium: AppTextStyle.bodyMedium.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        bodySmall: AppTextStyle.bodySmall.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        labelLarge: AppTextStyle.button.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        labelMedium: AppTextStyle.caption.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
        labelSmall: AppTextStyle.underline.copyWith(
          color: CustomThemeExtension.darkMode.contentPrimary,
        ),
      ),
    );
  }
}
