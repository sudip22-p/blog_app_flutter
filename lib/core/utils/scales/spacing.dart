import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

/// Default Spacing in App UI.
abstract class AppSpacing {
  /// The default unit of spacing
  static const double baseSpacing = 16;

  /// xxxs spacing value (1pt)
  static const double xxxs = (0.0625 * baseSpacing);

  /// xxs spacing value (2pt)
  static const double xxs = (0.125 * baseSpacing);

  /// xs spacing value (4pt)
  static const double xs = (0.25 * baseSpacing);

  /// sm spacing value (8pt): basically for inter widget spacing like gap between textfield
  static const double sm = (0.5 * baseSpacing);

  /// md spacing value (12pt): basically for app widget padding
  static const double md = (0.75 * baseSpacing);

  /// lg spacing value (16pt) :
  static const double lg = (baseSpacing);

  /// xlg spacing value (24pt) : basically for app horizontal pading
  static const double xlg = (1.5 * baseSpacing);

  /// xxlg spacing value (40pt) : for small big spacing
  static const double xxlg = (2.5 * baseSpacing);

  /// xxxlg pacing value (64pt) : for big spacing
  static const double xxxlg = (4 * baseSpacing);
}

// Optimized gap system with precomputed values
class AppGaps {
  // Precomputed gap values
  static double _gapW1 = 1.0, _gapW2 = 2.0, _gapW4 = 4.0, _gapW8 = 8.0;
  static double _gapW12 = 12.0, _gapW16 = 16.0, _gapW24 = 24.0;
  static double _gapW40 = 40.0, _gapW64 = 64.0;

  static double _gapH1 = 1.0, _gapH2 = 2.0, _gapH4 = 4.0, _gapH8 = 8.0;
  static double _gapH12 = 12.0, _gapH16 = 16.0, _gapH24 = 24.0;
  static double _gapH40 = 40.0, _gapH64 = 64.0;

  static void updateAllGaps() {
    _gapW1 = (AppSpacing.xxxs).w;
    _gapW2 = (AppSpacing.xxs).w;
    _gapW4 = (AppSpacing.xs).w;
    _gapW8 = (AppSpacing.sm).w;
    _gapW12 = (AppSpacing.md).w;
    _gapW16 = (AppSpacing.lg).w;
    _gapW24 = (AppSpacing.xlg).w;
    _gapW40 = (AppSpacing.xxlg).w;
    _gapW64 = (AppSpacing.xxxlg).w;

    _gapH1 = (AppSpacing.xxxs).h;
    _gapH2 = (AppSpacing.xxs).h;
    _gapH4 = (AppSpacing.xs).h;
    _gapH8 = (AppSpacing.sm).h;
    _gapH12 = (AppSpacing.md).h;
    _gapH16 = (AppSpacing.lg).h;
    _gapH24 = (AppSpacing.xlg).h;
    _gapH40 = (AppSpacing.xxlg).h;
    _gapH64 = (AppSpacing.xxxlg).h;
  }

  // Getters for const-like performance
  static SizedBox get gapW1 => SizedBox(width: _gapW1);
  static SizedBox get gapW2 => SizedBox(width: _gapW2);
  static SizedBox get gapW4 => SizedBox(width: _gapW4);
  static SizedBox get gapW8 => SizedBox(width: _gapW8);
  static SizedBox get gapW12 => SizedBox(width: _gapW12);
  static SizedBox get gapW16 => SizedBox(width: _gapW16);
  static SizedBox get gapW24 => SizedBox(width: _gapW24);
  static SizedBox get gapW40 => SizedBox(width: _gapW40);
  static SizedBox get gapW64 => SizedBox(width: _gapW64);

  static SizedBox get gapH1 => SizedBox(height: _gapH1);
  static SizedBox get gapH2 => SizedBox(height: _gapH2);
  static SizedBox get gapH4 => SizedBox(height: _gapH4);
  static SizedBox get gapH8 => SizedBox(height: _gapH8);
  static SizedBox get gapH12 => SizedBox(height: _gapH12);
  static SizedBox get gapH16 => SizedBox(height: _gapH16);
  static SizedBox get gapH24 => SizedBox(height: _gapH24);
  static SizedBox get gapH40 => SizedBox(height: _gapH40);
  static SizedBox get gapH64 => SizedBox(height: _gapH64);

  // Custom gap functions
  static SizedBox gapWCustom(double width) => SizedBox(width: width.w);
  static SizedBox gapHCustom(double height) => SizedBox(height: height.h);
}
