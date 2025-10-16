import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewCommentTopSection extends StatefulWidget {
  const PreviewCommentTopSection({
    super.key,
    required this.blog,
    required TextEditingController commentController,
  }) : _commentController = commentController;

  final TextEditingController _commentController;
  final Blog blog;

  @override
  State<PreviewCommentTopSection> createState() =>
      _PreviewCommentTopSectionState();
}

class _PreviewCommentTopSectionState extends State<PreviewCommentTopSection> {
  void addComment(String blogId) {
    if (widget._commentController.text.trim().isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';

    if (userId != null) {
      final comment = BlogComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        userAvatar: FirebaseAuth.instance.currentUser?.photoURL ?? '',
        content: widget._commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      BlocProvider.of<EngagementBloc>(context).add(AddComment(blogId, comment));
    }

    widget._commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: context.customTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<EngagementBloc, EngagementState>(
                builder: (context, state) {
                  int commentCount = 0;
                  if (state is EngagementLoaded) {
                    commentCount = state.engagement.commentsCount;
                  }

                  return Text(
                    'Comments ($commentCount)',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            // Add comment field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: context.customTheme.surface,
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: context.customTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: widget._commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      addComment(widget.blog.id);
                    },
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: context.customTheme.primary,
                      foregroundColor: context.customTheme.contentPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
