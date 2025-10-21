import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/modules/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/bloc/engagement_bloc.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_stat_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogStats extends StatefulWidget {
  final Blog blog;

  const BlogStats({super.key, required this.blog});

  @override
  State<BlogStats> createState() => BlogStatsState();
}

class BlogStatsState extends State<BlogStats> {
  bool isLiking = false;
  BlogEngagement? engagement;
  bool isLoading = false;
  bool? isLikedByUser;

  @override
  void initState() {
    super.initState();
    loadEngagement();
  }

  Future<void> loadEngagement() async {
    setState(() {
      isLoading = true;
    });

    try {
      final service = RealtimeDatabaseEngagementService();
      final engagementData = await service.getBlogEngagement(widget.blog.id);
      final likesData = engagementData.likes;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      print("userId : $userId");
      if (mounted) {
        setState(() {
          engagement = engagementData;
          isLikedByUser = likesData[userId];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void handleLikeTap() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || isLiking) return;

    setState(() {
      isLiking = true;
    });

    try {
      final service = RealtimeDatabaseEngagementService();
      await service.toggleLike(widget.blog.id, userId);

      // Reload engagement data to get updated counts
      await loadEngagement();

      if (mounted) {
        setState(() {
          isLiking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLiking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final likeCount = engagement?.likesCount ?? 0;
    final viewCount = engagement?.viewsCount ?? 0;
    final commentCount = engagement?.commentsCount ?? 0;
    print("engagements: " + engagement.toString());
    print("is liked : $isLikedByUser");

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: context.customTheme.surface,
          borderRadius: AppBorderRadius.mediumBorderRadius,
          border: Border.all(
            color: context.customTheme.outline,
            width: AppSpacing.xxxs,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              child: CircularProgressIndicator(
                strokeWidth: AppSpacing.xxs,
                color: context.customTheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: AppBorderRadius.mediumBorderRadius,
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.15),
          width: AppSpacing.xxxs,
        ),
      ),
      child: Column(
        children: [
          //  engagement stats
          BlocBuilder<EngagementBloc, EngagementState>(
            builder: (context, state) {
              print("state: $state");
              int viewCount = 0;
              int likeCount = 0;
              int commentCount = 0;

              if (state is EngagementInitial) {
                context.read<EngagementBloc>().add(
                  LoadBlogEngagement(widget.blog.id),
                );
              }
              if (state is EngagementLoaded) {
                viewCount = state.engagement.viewsCount;
                likeCount = state.engagement.likesCount;
                commentCount = state.engagement.commentsCount;
              }

              return Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: context.customTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$viewCount views',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.contentSurface,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.thumb_up_alt_rounded,
                    size: 16,
                    color: context.customTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$likeCount likes',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.contentSurface,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.comment,
                    size: 16,
                    color: context.customTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$commentCount comments',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.contentSurface,
                    ),
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                icon: Icons.thumb_up,
                count: likeCount,
                color: context.customTheme.primary,
                isLoading: isLiking,
                onTap: () => handleLikeTap(),
              ),

              StatItem(
                icon: Icons.visibility_rounded,
                count: viewCount,
                color: context.customTheme.contentPrimary,
                isLoading: false,
              ),

              StatItem(
                icon: Icons.message_rounded,
                count: commentCount,
                color: context.customTheme.contentPrimary,
                isLoading: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
