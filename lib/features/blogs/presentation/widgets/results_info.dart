import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ), // Ultra-compact padding
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 
          0.4,
        ), // Lighter background
        borderRadius: BorderRadius.circular(6), // Smaller radius
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 
            0.2,
          ), // More subtle border
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _ResultsIcon(theme: theme, hasResults: totalResults > 0),
          const SizedBox(width: 8), // Reduced spacing
          Expanded(
            child: _ResultsText(
              totalResults: totalResults,
              searchQuery: searchQuery,
              selectedTag: selectedTag,
              theme: theme,
            ),
          ),
          if (totalPages > 1) ...[
            const SizedBox(width: 8),
            _PageInfo(
              currentPage: currentPage,
              totalPages: totalPages,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsIcon extends StatelessWidget {
  final ThemeData theme;
  final bool hasResults;

  const _ResultsIcon({required this.theme, required this.hasResults});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4), // Smaller padding
      decoration: BoxDecoration(
        color: hasResults
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6) // Lighter
            : theme.colorScheme.errorContainer.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: Icon(
        hasResults ? Icons.filter_list_rounded : Icons.filter_list_off_rounded,
        size: 14, // Smaller icon
        color: hasResults
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onErrorContainer,
      ),
    );
  }
}

class _ResultsText extends StatelessWidget {
  final int totalResults;
  final String searchQuery;
  final String? selectedTag;
  final ThemeData theme;

  const _ResultsText({
    required this.totalResults,
    required this.searchQuery,
    required this.selectedTag,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.labelMedium?.copyWith(
              // Smaller text
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: totalResults.toString(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' blog${totalResults != 1 ? 's' : ''} found',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
        ),
        if (searchQuery.isNotEmpty || selectedTag != null) ...[
          const SizedBox(height: 1), // Minimal spacing
          _FilterInfo(
            searchQuery: searchQuery,
            selectedTag: selectedTag,
            theme: theme,
          ),
        ],
      ],
    );
  }
}

class _FilterInfo extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;
  final ThemeData theme;

  const _FilterInfo({
    required this.searchQuery,
    required this.selectedTag,
    required this.theme,
  });

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
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
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
  final ThemeData theme;

  const _PageInfo({
    required this.currentPage,
    required this.totalPages,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$currentPage/$totalPages',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
