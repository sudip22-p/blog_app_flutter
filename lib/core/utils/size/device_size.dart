import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class Device {
  static late BoxConstraints boxConstraints;
  static late double height;
  static late double width;
  static late double statusBar;
  static late double bottomBar;

  // Cache MediaQuery data to avoid repeated lookups
  static MediaQueryData? _cachedMediaQuery;

  static double get safeAreaHeight => height - statusBar - bottomBar;
  static double get aspectRatio => width / height;
  static bool get isMobile => width < ResponsiveConfig.tabletBreakpoint;
  static bool get isTablet =>
      width >= ResponsiveConfig.tabletBreakpoint &&
      width < ResponsiveConfig.desktopBreakpoint;
  static bool get isDesktop => width >= ResponsiveConfig.desktopBreakpoint;
  static bool get isLandscape => aspectRatio > 1.0;

  static BoxConstraints get contentConstraints =>
      BoxConstraints(maxWidth: width, maxHeight: safeAreaHeight);

  static void setScreenSize(BuildContext context, BoxConstraints constraints) {
    // Cache MediaQuery data once per build
    final mq = MediaQuery.of(context);
    _cachedMediaQuery = mq;

    boxConstraints = constraints;
    width = constraints.maxWidth;
    height = constraints.maxHeight;
    statusBar = mq.padding.top;
    bottomBar = mq.padding.bottom;

    // Update all caches at once
    _updateAllCaches();
  }

  static void _updateAllCaches() {
    // Clear responsive cache
    OptimizedResponsiveExtension.clearCache();
    // Update gap values
    AppGaps.updateAllGaps();
    // Update border radius values
    AppBorderRadius.updateAllBorderRadius();
  }

  // Safe way to get MediaQuery if needed elsewhere
  static MediaQueryData get mediaQuery => _cachedMediaQuery!;
}
