import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

/// Custom theme extension to safely access design tokens from AppColors.
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  // Accent colors
  final Color primary;
  final Color secondary;

  //Status Colors
  final Color error;
  final Color success;
  final Color info;

  //Text Colors
  final Color contentPrimary;
  final Color contentBackground;
  final Color contentSurface;

  //Others
  final Color background;
  final Color surface;
  final Color outline;

  const CustomThemeExtension({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.success,
    required this.info,
    required this.contentPrimary,
    required this.contentBackground,
    required this.contentSurface,
    required this.background,
    required this.surface,
    required this.outline,
  });

  // Light theme
  static const lightMode = CustomThemeExtension(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    success: AppColors.success,
    info: AppColors.info,
    contentPrimary: AppColors.lightOnPrimary,
    contentBackground: AppColors.lightOnBackground,
    contentSurface: AppColors.lightOnSurface,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    outline: AppColors.lightOutline,
  );

  // Dark theme
  static const darkMode = CustomThemeExtension(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    success: AppColors.success,
    info: AppColors.info,
    contentPrimary: AppColors.darkOnPrimary,
    contentBackground: AppColors.darkOnBackground,
    contentSurface: AppColors.darkOnSurface,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    outline: AppColors.darkOutline,
  );

  @override
  CustomThemeExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? error,
    Color? success,
    Color? info,
    Color? contentPrimary,
    Color? contentBackground,
    Color? contentSurface,
    Color? background,
    Color? surface,
    Color? outline,
  }) {
    return CustomThemeExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      success: success ?? this.success,
      info: info ?? this.info,
      contentPrimary: contentPrimary ?? this.contentPrimary,
      contentBackground: contentBackground ?? this.contentBackground,
      contentSurface: contentSurface ?? this.contentSurface,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      outline: outline ?? this.outline,
    );
  }

  @override
  CustomThemeExtension lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      contentPrimary: Color.lerp(contentPrimary, other.contentPrimary, t)!,
      contentBackground: Color.lerp(
        contentBackground,
        other.contentBackground,
        t,
      )!,
      contentSurface: Color.lerp(contentSurface, other.contentSurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
    );
  }
}
