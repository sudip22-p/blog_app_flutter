import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class BlogTitle extends StatelessWidget {
  final String title;

  const BlogTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
