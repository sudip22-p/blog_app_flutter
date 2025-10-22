import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    this.onPreviousPage,
    this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: currentPage > 1 && !isLoading ? onPreviousPage : null,
          color: context.customTheme.primary,
          tooltip: 'Previous',
        ),

        AppGaps.gapW12,

        isLoading
            ? SizedBox(
                width: AppSpacing.lg,
                height: AppSpacing.lg,
                child: CircularProgressIndicator(strokeWidth: AppSpacing.xxs),
              )
            : Text(
                '$currentPage / $totalPages',
                style: context.textTheme.bodyMedium,
              ),

        AppGaps.gapW12,

        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: currentPage < totalPages && !isLoading ? onNextPage : null,
          color: context.customTheme.primary,
          tooltip: 'Next',
        ),
      ],
    );
  }
}
