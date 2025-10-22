import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/widgets/chip_bar_item.dart';
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
    return SizedBox(
      height: 28,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          ChipItem(
            context: context,
            label: 'All',
            isSelected: selectedTag == null,
            onTap: () => onTagSelected(null),
          ),
          ...availableTags.map(
            (tag) => ChipItem(
              context: context,
              label: tag,
              isSelected: selectedTag == tag,
              onTap: () => onTagSelected(tag),
            ),
          ),
        ],
      ),
    );
  }
}
