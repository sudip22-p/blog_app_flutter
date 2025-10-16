import 'package:blog_app/core/utils/utils.dart';
import 'package:flutter/material.dart';

class AppElevation {
  // Precomputed elevation values
  static Offset? _lowAboveElevationOffset;
  static Offset? _lowDownElevationOffset;
  static Offset? _shallowAboveElevationOffset;
  static Offset? _shallowDownElevationOffset;
  static Offset? _deepAboveOffset;
  static Offset? _deepDownOffset;

  static double? _lowAboveElevationRadius;
  static double? _lowDownElevationRadius;
  static double? _shallowAboveElevationRadius;
  static double? _shallowDownElevationRadius;
  static double? _deepAboveRadius;
  static double? _deepDownRadius;

  static void updateAllElevations() {
    _lowAboveElevationOffset = Offset(0.0, -4.r);
    _lowDownElevationOffset = Offset(0, 5.r);
    _shallowAboveElevationOffset = Offset(0.0, -4.r);
    _shallowDownElevationOffset = Offset(0.0, 4.r);
    _deepAboveOffset = Offset(0.0, -16.r);
    _deepDownOffset = Offset(0.0, 16.r);

    _lowAboveElevationRadius = 4.0;
    _lowDownElevationRadius = 5.0;
    _shallowAboveElevationRadius = 16.0;
    _shallowDownElevationRadius = 16.0;
    _deepAboveRadius = 48.0;
    _deepDownRadius = 48.0;
  }

  // Getters
  static Offset get lowAboveElevationOffset => _lowAboveElevationOffset!;
  static Offset get lowDownElevationOffset => _lowDownElevationOffset!;
  static Offset get shallowAboveElevationOffset =>
      _shallowAboveElevationOffset!;
  static Offset get shallowDownElevationOffset => _shallowDownElevationOffset!;
  static Offset get deepAboveOffset => _deepAboveOffset!;
  static Offset get deepDownOffset => _deepDownOffset!;

  static double get lowAboveElevationRadius => _lowAboveElevationRadius!;
  static double get lowDownElevationRadius => _lowDownElevationRadius!;
  static double get shallowAboveElevationRadius =>
      _shallowAboveElevationRadius!;
  static double get shallowDownElevationRadius => _shallowDownElevationRadius!;
  static double get deepAboveRadius => _deepAboveRadius!;
  static double get deepDownRadius => _deepDownRadius!;
}
