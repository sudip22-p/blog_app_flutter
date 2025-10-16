import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const SearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      height: 48,
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.customTheme.outline.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Search blogs, authors, topics...',
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.customTheme.contentPrimary.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          prefixIcon: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              Icons.search_rounded,
              color: context.customTheme.contentPrimary.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: context.customTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: context.customTheme.contentPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
