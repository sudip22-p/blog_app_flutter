import 'dart:math' as math;

import 'package:blog_app/core/core.dart';

extension OptimizedResponsiveExtension on num {
  // Cache scale factors - calculated once per layout change
  static double? _cachedWidthScale;
  static double? _cachedHeightScale;
  static double? _cachedBalancedScale;
  static double? _cachedFontScale;

  static void _updateCache() {
    if (_cachedWidthScale != null) return;

    final screenWidth = Device.width;
    final safeAreaHeight = Device.safeAreaHeight;

    _cachedWidthScale = (screenWidth / FigmaDesign.width).clamp(
      ResponsiveConfig.minScaleFactor,
      ResponsiveConfig.maxScaleFactor,
    );

    _cachedHeightScale = (safeAreaHeight / FigmaDesign.contentHeight).clamp(
      ResponsiveConfig.minScaleFactor,
      ResponsiveConfig.maxScaleFactor,
    );

    _cachedBalancedScale = math.sqrt(_cachedWidthScale! * _cachedHeightScale!);

    double fontScale = _cachedBalancedScale!;
    if (Device.isDesktop) {
      fontScale *= 0.95;
    } else if (Device.isTablet) {
      fontScale *= 1.0;
    } else {
      fontScale *= 1.05;
    }

    _cachedFontScale = fontScale.clamp(
      ResponsiveConfig.minFontScaleFactor,
      ResponsiveConfig.maxFontScaleFactor,
    );
  }

  static void clearCache() {
    _cachedWidthScale = null;
    _cachedHeightScale = null;
    _cachedBalancedScale = null;
    _cachedFontScale = null;
  }

  // Optimized getters - use cached values
  /// For horizontal elements (rows, side margins)
  double get w {
    OptimizedResponsiveExtension._updateCache();
    return (this * _cachedWidthScale!).toDoubleValue();
  }

  /// For vertical elements (columns, top/bottom margins)
  double get h {
    OptimizedResponsiveExtension._updateCache();
    return (this * _cachedHeightScale!).toDoubleValue();
  }

  /// For uniform elements (icons, avatars, circular items)
  double get r {
    OptimizedResponsiveExtension._updateCache();
    return (this * _cachedBalancedScale!).toDoubleValue();
  }

  /// For fonts (always)
  double get sp {
    OptimizedResponsiveExtension._updateCache();
    return (this * _cachedFontScale!).toDoubleValue();
  }
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
