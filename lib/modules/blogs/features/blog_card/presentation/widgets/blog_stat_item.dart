import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;

  const StatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
    this.onTap,
    this.isLoading = false,
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
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? SizedBox(
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSpacing.xxs,
                    ),
                  )
                : Icon(icon, size: AppSpacing.lg, color: color),

            AppGaps.gapW4,

            Text(formatCount(count), style: context.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
