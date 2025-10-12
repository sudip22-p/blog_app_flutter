import 'package:flutter/material.dart';

class ExploreEmptyState extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;

  const ExploreEmptyState({
    super.key,
    required this.searchQuery,
    this.selectedTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmptyStateIcon(theme: theme),
            const SizedBox(height: 24),
            _EmptyStateTitle(
              searchQuery: searchQuery,
              selectedTag: selectedTag,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _EmptyStateMessage(
              searchQuery: searchQuery,
              selectedTag: selectedTag,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _EmptyStateActions(theme: theme),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateIcon extends StatelessWidget {
  final ThemeData theme;

  const _EmptyStateIcon({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.search_off_rounded,
        size: 56,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _EmptyStateTitle extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;
  final ThemeData theme;

  const _EmptyStateTitle({
    required this.searchQuery,
    required this.selectedTag,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    if (searchQuery.isNotEmpty && selectedTag != null) {
      title = 'No matching blogs found';
    } else if (searchQuery.isNotEmpty) {
      title = 'No search results';
    } else if (selectedTag != null) {
      title = 'No blogs with "$selectedTag" tag';
    } else {
      title = 'No blogs available';
    }

    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;
  final ThemeData theme;

  const _EmptyStateMessage({
    required this.searchQuery,
    required this.selectedTag,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    if (searchQuery.isNotEmpty && selectedTag != null) {
      message =
          'Try adjusting your search terms or removing the filter to find more blogs.';
    } else if (searchQuery.isNotEmpty) {
      message =
          'We couldn\'t find any blogs matching "$searchQuery". Try different keywords.';
    } else if (selectedTag != null) {
      message =
          'There are currently no blogs tagged with "$selectedTag". Try a different tag.';
    } else {
      message = 'Check back later for new blog content.';
    }

    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyStateActions extends StatelessWidget {
  final ThemeData theme;

  const _EmptyStateActions({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Go to Home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Refreshing content...'),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }
}
