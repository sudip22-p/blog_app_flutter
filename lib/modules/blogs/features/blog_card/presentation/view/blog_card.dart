import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
//TODO: update path accordingly ....
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
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: AppBorderRadius.chipBorderRadius,
        boxShadow: AppShadow.shadow02,
      ),

      child: InkWell(
        borderRadius: AppBorderRadius.chipBorderRadius,
        onTap:
            onTap ??
            () => {context.pushNamed(Routes.blogDetails.name, extra: blog)},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImageSection(blog: blog),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagsSection(tags: blog.tags),

                  if (blog.tags.isNotEmpty) AppGaps.gapH8,

                  BlogTitle(title: blog.title),

                  AppGaps.gapH8,

                  BlogContent(content: blog.content),

                  AppGaps.gapH12,

                  AuthorSection(blog: blog),

                  AppGaps.gapH12,

                  BlogStats(blog: blog),

                  //for MyBlogs Page
                  if (showActions) ...[
                    AppGaps.gapH12,

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
