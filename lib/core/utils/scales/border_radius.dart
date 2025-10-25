import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

///[border radius]

class AppBorderRadius {
  // Precomputed border radius values
  static BorderRadius? _chipBorderRadius;
  static BorderRadius? _largeBorderRadius;
  static BorderRadius? _defaultBorderRadius;
  static BorderRadius? _mediumBorderRadius;
  static BorderRadius? _smallBorderRadius;

  static Radius? _chipRadius;
  static Radius? _largeRadius;
  static Radius? _defaultRadius;
  static Radius? _mediumRadius;
  static Radius? _smallRadius;

  static void updateAllBorderRadius() {
    _chipBorderRadius = BorderRadius.circular(20.r);
    _largeBorderRadius = BorderRadius.circular(16.r);
    _defaultBorderRadius = BorderRadius.circular(12.r);
    _mediumBorderRadius = BorderRadius.circular(8.r);
    _smallBorderRadius = BorderRadius.circular(4.r);

    _chipRadius = Radius.circular(20.r);
    _largeRadius = Radius.circular(16.r);
    _defaultRadius = Radius.circular(12.r);
    _mediumRadius = Radius.circular(8.r);
    _smallRadius = Radius.circular(4.r);
  }

  // Getters
  static BorderRadius get chipBorderRadius => _chipBorderRadius!;
  static BorderRadius get largeBorderRadius => _largeBorderRadius!;
  static BorderRadius get defaultBorderRadius => _defaultBorderRadius!;
  static BorderRadius get mediumBorderRadius => _mediumBorderRadius!;
  static BorderRadius get smallBorderRadius => _smallBorderRadius!;

  static Radius get chipRadius => _chipRadius!;
  static Radius get largeRadius => _largeRadius!;
  static Radius get defaultRadius => _defaultRadius!;
  static Radius get mediumRadius => _mediumRadius!;
  static Radius get smallRadius => _smallRadius!;
}
