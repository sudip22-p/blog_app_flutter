import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const StatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
    this.onTap,
  });

  String formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: color),

            AppGaps.gapW4,

            Text(formatCount(count), style: context.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
