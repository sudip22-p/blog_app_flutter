import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class CustomAppIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const CustomAppIconButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      borderRadius: AppBorderRadius.chipBorderRadius,
      child: Container(padding: EdgeInsets.all(8), child: child),
    );
  }
}

class CustomAppTextIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Widget icon;
  final Widget? gap;
  final EdgeInsetsGeometry? padding;
  final IconAlignment iconAlignment;
  const CustomAppTextIconButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.icon,
    this.iconAlignment = IconAlignment.end,
    this.gap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      borderRadius: AppBorderRadius.chipBorderRadius,
      child: Container(
        padding: padding ?? EdgeInsets.all(8),
        child: Row(
          children: [
            if (iconAlignment == IconAlignment.start) ...[
              icon,
              gap ?? AppGaps.gapW8,
            ],
            child,
            if (iconAlignment == IconAlignment.end) ...[
              gap ?? AppGaps.gapW8,
              icon,
            ],
          ],
        ),
      ),
    );
  }
}
