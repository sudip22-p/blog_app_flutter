import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: AppBorderRadius.largeBorderRadius,
        border: Border.all(
          color: context.customTheme.outline,
          width: AppSpacing.xxxs,
        ),
        boxShadow: AppShadow.shadow01,
      ),

      child: TextField(
        style: context.textTheme.bodyMedium,

        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search blogs, authors, topics...',
          hintStyle: context.textTheme.bodySmall,
          isCollapsed: true,

          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.customTheme.contentPrimary.withValues(alpha: 0.7),
            size: AppSpacing.xlg,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? InkWell(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    color: context.customTheme.error,
                    size: AppSpacing.xlg,
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
