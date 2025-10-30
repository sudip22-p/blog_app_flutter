import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewCommentList extends StatelessWidget {
  final BlogEntity blog;
  const PreviewCommentList({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EngagementBloc, EngagementState>(
      builder: (context, state) {
        List<BlogCommentEntity> comments = [];
        if (state is EngagementLoaded) {
          final blogEngagement = state.engagements.firstWhere(
            (eng) => eng.blogId == blog.id,
            orElse: () => BlogEngagementEntity(
              blogId: blog.id!,
              likesCount: 0,
              commentsCount: 0,
              viewsCount: 0,
              likes: {},
              comments: [],
              views: {},
            ),
          );
          comments = blogEngagement.comments;
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final comment = comments[index];
            return Container(
              color: context.customTheme.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageAvatar(
                      size: AppSpacing.xxlg,
                      imageUrl: comment.userAvatar,
                      fit: BoxFit.cover,
                      placeHolderImage: AssetRoutes.defaultAvatarImagePath,
                    ),

                    AppGaps.gapW12,

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.userName,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              AppGaps.gapW8,

                              Text(
                                DatetimeUtils.formatTimeAgo(comment.createdAt),
                                style: context.textTheme.bodySmall,
                              ),
                            ],
                          ),

                          AppGaps.gapH2,

                          Text(
                            comment.content,
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }, childCount: comments.length),
        );
      },
    );
  }
}
