import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class ResultsInfo extends StatelessWidget {
  final int totalResults;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final String? selectedTag;

  const ResultsInfo({
    super.key,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
    required this.searchQuery,
    this.selectedTag,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      if (searchQuery.isNotEmpty) '"$searchQuery"',
      if (selectedTag != null) '#$selectedTag',
    ];

    if (searchQuery.isEmpty && selectedTag == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Icon(
            totalResults > 0
                ? Icons.filter_alt_rounded
                : Icons.filter_alt_off_rounded,
            size: AppSpacing.xlg,
            color: totalResults > 0
                ? context.customTheme.primary
                : context.customTheme.error,
          ),

          AppGaps.gapW8,

          Expanded(
            child: Text(
              '$totalResults blog${totalResults != 1 ? 's' : ''} found'
              '${filters.isNotEmpty ? ' • ${filters.join(', ')}' : ''}',
              style: context.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (totalPages > 1)
            Text(
              '$currentPage/$totalPages',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.customTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
