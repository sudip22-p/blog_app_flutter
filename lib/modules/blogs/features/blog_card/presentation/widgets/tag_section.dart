import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class TagsSection extends StatelessWidget {
  final List<String> tags;

  const TagsSection({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.customTheme.outline.withValues(alpha: 0.15),
            borderRadius: AppBorderRadius.mediumBorderRadius,
          ),
          child: Text(
            tag,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.customTheme.contentBackground,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
