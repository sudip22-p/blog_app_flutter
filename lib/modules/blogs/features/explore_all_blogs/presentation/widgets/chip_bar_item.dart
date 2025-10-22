import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class ChipItem extends StatelessWidget {
  const ChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.context,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final theme = context.customTheme;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.mediumBorderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.surface,
            borderRadius: AppBorderRadius.mediumBorderRadius,
            border: Border.all(
              color: isSelected ? theme.primary : theme.outline,
              width: AppSpacing.xxxs,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : theme.contentPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
