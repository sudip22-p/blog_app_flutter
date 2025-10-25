import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
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
        color: context.customTheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<EngagementBloc, EngagementState>(
                builder: (context, state) {
                  int commentCount = 0;
                  if (state is EngagementLoaded) {
                    final blogEngagement = state.engagements.firstWhere(
                      (eng) => eng.blogId == widget.blog.id,
                      orElse: () => BlogEngagement(
                        blogId: widget.blog.id,
                        likesCount: 0,
                        viewsCount: 0,
                        commentsCount: 0,
                      ),
                    );
                    commentCount = blogEngagement.commentsCount;
                  }

                  return Text(
                    'Comments ($commentCount)',
                    style: context.textTheme.titleSmall,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSpacing.xlg,
                    backgroundColor: context.customTheme.secondary,
                    child: Icon(
                      Icons.person,
                      size: AppSpacing.xlg,
                      color: context.customTheme.surface,
                    ),
                  ),

                  AppGaps.gapW4,

                  Expanded(
                    child: TextField(
                      style: context.textTheme.bodyMedium,
                      controller: widget._commentController,
                      decoration: InputDecoration(
                        hintText: 'Add your comment',
                        hintStyle: context.textTheme.bodyMedium,
                        border: OutlineInputBorder(
                          borderRadius: AppBorderRadius.defaultBorderRadius,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),

                  AppGaps.gapW4,

                  IconButton(
                    onPressed: () {
                      addComment(widget.blog.id);
                    },
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: context.customTheme.secondary,
                      foregroundColor: context.customTheme.surface,
                    ),
                  ),
                ],
              ),
            ),

            AppGaps.gapH16,
          ],
        ),
      ),
    );
  }
}
