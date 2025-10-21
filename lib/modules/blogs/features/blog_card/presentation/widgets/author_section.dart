import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:flutter/material.dart';

class AuthorSection extends StatelessWidget {
  final Blog blog;

  const AuthorSection({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.xxlg,
          height: AppSpacing.xxlg,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.customTheme.primary,
                context.customTheme.surface,
                context.customTheme.primary,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              blog.authorName.isNotEmpty
                  ? blog.authorName[0].toUpperCase()
                  : 'A',
              style: context.textTheme.bodyMedium,
            ),
          ),
        ),

        AppGaps.gapW8,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.authorName == "" ? "Anonymous" : blog.authorName,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DatetimeUtils.formatTimeAgo(blog.createdAt),
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
