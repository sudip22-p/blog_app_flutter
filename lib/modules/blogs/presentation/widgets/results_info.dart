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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.customTheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _ResultsIcon(hasResults: totalResults > 0),
          const SizedBox(width: 8),
          Expanded(
            child: _ResultsText(
              totalResults: totalResults,
              searchQuery: searchQuery,
              selectedTag: selectedTag,
            ),
          ),
          if (totalPages > 1) ...[
            const SizedBox(width: 8),
            _PageInfo(currentPage: currentPage, totalPages: totalPages),
          ],
        ],
      ),
    );
  }
}

class _ResultsIcon extends StatelessWidget {
  final bool hasResults;

  const _ResultsIcon({required this.hasResults});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hasResults
            ? context.customTheme.primary.withValues(alpha: 0.12)
            : context.customTheme.error.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        hasResults ? Icons.filter_list_rounded : Icons.filter_list_off_rounded,
        size: 14,
        color: hasResults
            ? context.customTheme.primary
            : context.customTheme.error,
      ),
    );
  }
}

class _ResultsText extends StatelessWidget {
  final int totalResults;
  final String searchQuery;
  final String? selectedTag;

  const _ResultsText({
    required this.totalResults,
    required this.searchQuery,
    required this.selectedTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: totalResults.toString(),
                style: TextStyle(
                  color: context.customTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' blog${totalResults != 1 ? 's' : ''} found',
                style: TextStyle(color: context.customTheme.contentPrimary),
              ),
            ],
          ),
        ),
        if (searchQuery.isNotEmpty || selectedTag != null) ...[
          const SizedBox(height: 1),
          _FilterInfo(searchQuery: searchQuery, selectedTag: selectedTag),
        ],
      ],
    );
  }
}

class _FilterInfo extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;

  const _FilterInfo({required this.searchQuery, required this.selectedTag});

  @override
  Widget build(BuildContext context) {
    final filters = <String>[];

    if (searchQuery.isNotEmpty) {
      filters.add('"$searchQuery"');
    }

    if (selectedTag != null) {
      filters.add('#$selectedTag');
    }

    if (filters.isEmpty) return const SizedBox.shrink();

    return Text(
      'Filtered by: ${filters.join(', ')}',
      style: context.textTheme.bodySmall?.copyWith(
        color: context.customTheme.contentSurface,
        fontStyle: FontStyle.italic,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _PageInfo extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageInfo({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.customTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$currentPage/$totalPages',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.customTheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
