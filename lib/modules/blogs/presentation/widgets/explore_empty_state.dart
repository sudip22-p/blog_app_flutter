import 'package:blog_app/core/core.dart';
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmptyStateIcon(),
            const SizedBox(height: 24),
            _EmptyStateTitle(
              searchQuery: searchQuery,
              selectedTag: selectedTag,
            ),
            const SizedBox(height: 12),
            _EmptyStateMessage(
              searchQuery: searchQuery,
              selectedTag: selectedTag,
            ),
            const SizedBox(height: 24),
            _EmptyStateActions(),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateIcon extends StatelessWidget {
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
            context.customTheme.surface,
            context.customTheme.surface.withValues(alpha: 0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.customTheme.outline,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.search_off_rounded,
        size: 56,
        color: context.customTheme.contentSurface,
      ),
    );
  }
}

class _EmptyStateTitle extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;

  const _EmptyStateTitle({
    required this.searchQuery,
    required this.selectedTag,
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
      style: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: context.customTheme.contentSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  final String searchQuery;
  final String? selectedTag;

  const _EmptyStateMessage({
    required this.searchQuery,
    required this.selectedTag,
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
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.customTheme.contentSurface,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyStateActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Go to Home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.customTheme.primary,
            foregroundColor: context.customTheme.contentPrimary,
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
                backgroundColor: context.customTheme.primary,
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
            foregroundColor: context.customTheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }
}
