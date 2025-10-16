import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class BlogTitle extends StatelessWidget {
  final String title;

  const BlogTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
