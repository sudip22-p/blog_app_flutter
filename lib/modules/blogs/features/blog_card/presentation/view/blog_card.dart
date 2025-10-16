import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/author_section.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_content.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_stats.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_title.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/cover_image_section.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/tag_section.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/user_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const BlogCard({
    super.key,
    required this.blog,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.1),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap ?? () => {context.pushNamed(Routes.blogDetails.name)},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImageSection(blog: blog),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagsSection(tags: blog.tags),
                  if (blog.tags.isNotEmpty) const SizedBox(height: 8),
                  BlogTitle(title: blog.title),
                  const SizedBox(height: 6),
                  BlogContent(content: blog.content),
                  const SizedBox(height: 12),
                  AuthorSection(blog: blog),
                  const SizedBox(height: 12),
                  BlogStats(blog: blog),
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    ActionButtons(onEdit: onEdit, onDelete: onDelete),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
