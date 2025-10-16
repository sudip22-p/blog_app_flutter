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
          width: 32,
          height: 32,
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
          ),
          child: Center(
            child: Text(
              blog.authorName.isNotEmpty
                  ? blog.authorName[0].toUpperCase()
                  : 'A',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.customTheme.contentPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.authorName == "" ? "Anonymous" : blog.authorName,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                formatTimeAgo(blog.createdAt),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.customTheme.contentSurface,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
