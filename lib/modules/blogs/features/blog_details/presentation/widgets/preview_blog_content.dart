import 'package:blog_app/common/router/asset_routes.dart';
import 'package:blog_app/common/widgets/custom_image_avatar.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/author_section.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_stats.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_title.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/tag_section.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class PreviewBlogContent extends StatelessWidget {
  const PreviewBlogContent({super.key, required this.blog});
  final Blog blog;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          if (blog.coverImageUrl != null)
            SizedBox(
              height: 210,
              child: CustomImageAvatar(
                imageUrl: blog.coverImageUrl!,
                shape: AvatarShape.rectangle,
                width: double.infinity,
                height: double.infinity,
                placeHolderImage: AssetRoutes.defaultPlaceholderImagePath,
              ),
            ),

          // Blog content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                if (blog.tags.isNotEmpty) AppGaps.gapH8,

                if (blog.tags.isNotEmpty) TagsSection(tags: blog.tags),

                AppGaps.gapH16,

                // Title
                BlogTitle(title: blog.title),

                AppGaps.gapH8,

                // Content
                Text(blog.content, style: context.textTheme.bodyMedium),

                AppGaps.gapH24,

                // Author and date
                AuthorSection(blog: blog),

                AppGaps.gapH8,

                BlogStats(blog: blog),

                AppGaps.gapH8,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
