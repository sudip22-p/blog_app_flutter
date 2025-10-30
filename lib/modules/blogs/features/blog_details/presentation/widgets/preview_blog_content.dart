import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/core/core.dart';

class PreviewBlogContent extends StatelessWidget {
  const PreviewBlogContent({super.key, required this.blog});
  final BlogEntity blog;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          SizedBox(
            height: 210,
            child: CustomImageAvatar(
              imageUrl: blog.coverImageUrl,
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

                // Author and date
                AuthorSection(blog: blog),

                AppGaps.gapH24,

                // Content
                Text(blog.content, style: context.textTheme.bodyMedium),

                AppGaps.gapH24,

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
