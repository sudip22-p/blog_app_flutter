import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class BlogContent extends StatelessWidget {
  final String content;

  const BlogContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.customTheme.contentPrimary,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
