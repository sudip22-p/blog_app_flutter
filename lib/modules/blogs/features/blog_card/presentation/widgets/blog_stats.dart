import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogStats extends StatefulWidget {
  final BlogEntity blog;

  const BlogStats({super.key, required this.blog});

  @override
  State<BlogStats> createState() => BlogStatsState();
}

class BlogStatsState extends State<BlogStats> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

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
          BlocBuilder<EngagementBloc, EngagementState>(
            builder: (context, state) {
              if (state is EngagementLoading || state is EngagementInitial) {
                return Center(
                  child: SizedBox(
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSpacing.xxs,
                      color: context.customTheme.primary,
                    ),
                  ),
                );
              }
              if (state is EngagementLoaded) {
                final blogEngagement = state.engagements.firstWhere(
                  (eng) => eng.blogId == widget.blog.id,
                  orElse: () => BlogEngagementEntity(
                    blogId: widget.blog.id!,
                    likesCount: 0,
                    commentsCount: 0,
                    viewsCount: 0,
                    likes: {},
                    comments: [],
                    views: {},
                  ),
                );
                final isLikedByUser =
                    blogEngagement.likes[currentUserId] == true;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatItem(
                      icon: Icons.thumb_up,
                      count: blogEngagement.likesCount,
                      color: isLikedByUser
                          ? context.customTheme.secondary
                          : context.customTheme.contentBackground,
                      onTap: () {
                        context.read<EngagementBloc>().add(
                          ToggleLike(widget.blog.id!, currentUserId),
                        );
                      },
                    ),

                    StatItem(
                      icon: Icons.visibility_rounded,
                      count: blogEngagement.viewsCount,
                      color: context.customTheme.contentPrimary,
                    ),

                    StatItem(
                      icon: Icons.message_rounded,
                      count: blogEngagement.commentsCount,
                      color: context.customTheme.contentPrimary,
                    ),
                  ],
                );
              }
              if (state is EngagementError) {
                return EmptyState(
                  icon: Icons.error,
                  title: 'Failed to Fetch the Stats!',
                  message: 'Reload Again to Fetch the Data.',
                  buttonText: 'Reload',
                  onButtonPressed: () {
                    context.goNamed(Routes.dashboard.name);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
