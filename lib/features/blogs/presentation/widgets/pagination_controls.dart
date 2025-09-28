import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            onPressed: currentPage > 1 ? onPreviousPage : null,
            icon: Icons.chevron_left_rounded,
            theme: theme,
            tooltip: 'Previous page',
          ),
          const SizedBox(width: 20),
          _PageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            theme: theme,
          ),
          const SizedBox(width: 20),
          isLoading
              ? _LoadingIndicator(theme: theme)
              : _PaginationButton(
                  onPressed: currentPage < totalPages ? onNextPage : null,
                  icon: Icons.chevron_right_rounded,
                  theme: theme,
                  tooltip: 'Next page',
                ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final ThemeData theme;
  final String tooltip;

  const _PaginationButton({
    required this.onPressed,
    required this.icon,
    required this.theme,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onPressed != null
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: theme.shadowColor,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              icon,
              color: onPressed != null
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ThemeData theme;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Page $currentPage of $totalPages',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final ThemeData theme;

  const _LoadingIndicator({required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
