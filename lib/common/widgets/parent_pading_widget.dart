import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class ParentPaddingWidget extends StatelessWidget {
  ParentPaddingWidget({
    super.key,
    required this.child,
    double? left,
    double? top,
    double? right,
    double? bottom,

    this.hasSafeArea = false,
  }) : left = left ?? AppSpacing.lg.r,
       top = top ?? AppSpacing.lg.r,
       right = right ?? AppSpacing.lg.r,
       bottom = bottom ?? AppSpacing.lg.r;
  final Widget child;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final bool hasSafeArea;

  @override
  Widget build(BuildContext context) {
    return hasSafeArea
        ? SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: left,
                top: top,
                right: right,
                bottom: bottom,
              ),
              child: child,
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
            ),
            child: child,
          );
  }
}
