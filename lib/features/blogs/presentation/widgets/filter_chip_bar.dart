import 'package:flutter/material.dart';

class FilterChipBar extends StatelessWidget {
  final List<String> availableTags;
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;

  const FilterChipBar({
    super.key,
    required this.availableTags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 36, // Reduced from 44 to 36 for ultra-compact
      margin: const EdgeInsets.only(bottom: 2), // Minimal margin
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildAllChip(theme),
          const SizedBox(width: 4), // Tighter spacing
          ...availableTags.map(
            (tag) => Padding(
              padding: const EdgeInsets.only(right: 4), // Tighter spacing
              child: _buildTagChip(tag, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllChip(ThemeData theme) {
    final isSelected = selectedTag == null;

    return _ChipContainer(
      isSelected: isSelected,
      theme: theme,
      onTap: () => onTagSelected(null),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.apps_rounded,
            size: 12, // Even smaller icon
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
          ),
          const SizedBox(width: 3), // Minimal spacing
          Text(
            'All',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11, // Smaller font
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag, ThemeData theme) {
    final isSelected = selectedTag == tag;

    return _ChipContainer(
      isSelected: isSelected,
      theme: theme,
      onTap: () => onTagSelected(tag),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4, // Even smaller dot
            height: 4,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                  : theme.colorScheme.primary.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4), // Minimal spacing
          Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 11, // Smaller font
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipContainer extends StatelessWidget {
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;
  final Widget child;

  const _ChipContainer({
    required this.isSelected,
    required this.theme,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      elevation: isSelected ? 2 : 0,
      shadowColor: theme.shadowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ), // Ultra-compact padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? null
                : Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    width: 1,
                  ),
          ),
          child: child,
        ),
      ),
    );
  }
}
