import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/modules/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/widgets/blog_stat_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
      if (mounted) {
        setState(() {
          engagement = engagementData;
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

  @override
  Widget build(BuildContext context) {
    // Use local state instead of BLoC for simple display
    final likeCount = engagement?.likesCount ?? 0;
    final viewCount = engagement?.viewsCount ?? 0;
    final commentCount = engagement?.commentsCount ?? 0;

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.customTheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.customTheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.customTheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.customTheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
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
            color: context.customTheme.secondary,
            isLoading: false,
          ),
          StatItem(
            icon: Icons.message_rounded,
            count: commentCount,
            color: context.customTheme.secondary,
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void handleLikeTap() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || isLiking) return;

    // Simple loading state
    setState(() {
      isLiking = true;
    });

    try {
      // Direct database call
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
}




