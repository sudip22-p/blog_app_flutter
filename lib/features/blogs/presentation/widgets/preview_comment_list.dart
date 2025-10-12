import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/features/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewCommentList extends StatelessWidget {
  const PreviewCommentList({super.key, required this.theme});

  final ThemeData theme;
  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EngagementBloc, EngagementState>(
      builder: (context, state) {
        List<BlogComment> comments = [];
        if (state is EngagementLoaded) {
          comments = state.engagement.commentsList;
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final comment = comments[index];
            return Container(
              color: theme.colorScheme.surfaceContainerLowest,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final hasValidAvatar =
                            comment.userAvatar.isNotEmpty &&
                            Uri.tryParse(comment.userAvatar)?.hasScheme == true;

                        return CircleAvatar(
                          radius: 16,
                          backgroundImage: hasValidAvatar
                              ? NetworkImage(comment.userAvatar)
                              : null,
                          onBackgroundImageError: hasValidAvatar
                              ? (exception, stackTrace) {
                                  // Handle image loading errors gracefully
                                }
                              : null,
                          child: Text(
                            comment.userName.isNotEmpty
                                ? comment.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.userName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatTimeAgo(comment.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            style: theme.textTheme.bodyMedium,
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
