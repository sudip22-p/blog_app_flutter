import 'package:flutter/material.dart';

/// Raw design tokens from Figma (DO NOT use directly in widgets).
/// Always access via [CustomThemeExtension].
class AppColors {
  AppColors._();

  // accent Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF186ADE);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFFBF4815);

  // Light Theme Colors
  static const Color lightOnPrimary = Color(0xFF000000);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightOnBackground = Color(0xFF1E293B);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightOutline = Color(0xFF475569);

  // Dark Theme Colors
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkOnBackground = Color(0xFFF1F5F9);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkOutline = Color(0xFFCBD5E1);
}
