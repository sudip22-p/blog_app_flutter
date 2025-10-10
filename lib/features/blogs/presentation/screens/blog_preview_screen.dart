import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/features/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:blog_app/features/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogPreviewScreen extends StatefulWidget {
  final Blog blog;

  const BlogPreviewScreen({super.key, required this.blog});

  @override
  State<BlogPreviewScreen> createState() => _BlogPreviewScreenState();
}

class _BlogPreviewScreenState extends State<BlogPreviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _hasAddedView = false;

  @override
  void initState() {
    super.initState();

    // Load engagement data and add view in one call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EngagementBloc>().add(
        StartBlogEngagementStream(widget.blog.id),
      );
      _addViewIfNeeded();
    });

    // Load user favorites data
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<FavoritesBloc>().add(LoadUserFavorites(userId));
    }
  }

  void _addViewIfNeeded() {
    if (!_hasAddedView) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        context.read<EngagementBloc>().add(AddView(widget.blog.id, userId));
        _hasAddedView = true;
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleFavourite() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<FavoritesBloc>().add(ToggleFavorite(userId, widget.blog.id));
    }
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';

    if (userId != null) {
      final comment = BlogComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        userAvatar: FirebaseAuth.instance.currentUser?.photoURL ?? '',
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      BlocProvider.of<EngagementBloc>(
        context,
      ).add(AddComment(widget.blog.id, comment));
    }

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _shareContent() {
    final shareText =
        'Check out this amazing blog post: "${widget.blog.title}" by ${widget.blog.authorName}';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              bool isFavourite = false;
              if (state is FavoritesLoaded) {
                isFavourite = state.isFavorited(widget.blog.id);
              }

              return IconButton(
                onPressed: _toggleFavourite,
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: isFavourite ? theme.colorScheme.primary : null,
                ),
              );
            },
          ),
          IconButton(onPressed: _shareContent, icon: const Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Blog content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover image
                if (widget.blog.coverImageUrl != null)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.blog.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(
                                Icons.article,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // Blog content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags
                      if (widget.blog.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.blog.tags.map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: theme.textTheme.labelSmall,
                              ),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              side: BorderSide.none,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        widget.blog.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Author and date
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              widget.blog.authorName.isNotEmpty
                                  ? widget.blog.authorName[0].toUpperCase()
                                  : 'A',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.blog.authorName == ""
                                    ? "Anonymous"
                                    : widget.blog.authorName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatTimeAgo(widget.blog.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Dynamic Stats with BLoC
                      BlocBuilder<EngagementBloc, EngagementState>(
                        builder: (context, state) {
                          int viewCount = 0;
                          int likeCount = 0;
                          int commentCount = 0;

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
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$viewCount views',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.thumb_up_alt_rounded,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$likeCount likes',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.comment,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$commentCount comments',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Content
                      Text(
                        widget.blog.content,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(child: _LikeButton(blogId: widget.blog.id)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Scroll to comments section
                              },
                              icon: const Icon(Icons.comment, size: 18),
                              label: const Text('Comment'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Comments section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
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
                          style: theme.textTheme.titleMedium?.copyWith(
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
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
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
                          onPressed: _addComment,
                          icon: const Icon(Icons.send),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Comments list
          BlocBuilder<EngagementBloc, EngagementState>(
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
                                  Uri.tryParse(comment.userAvatar)?.hasScheme ==
                                      true;

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
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTimeAgo(comment.createdAt),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
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
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;

  Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timestamp,
    required this.likes,
  });
}

class _LikeButton extends StatefulWidget {
  final String blogId;

  const _LikeButton({required this.blogId});

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<EngagementBloc, EngagementState>(
      builder: (context, state) {
        bool isLiked = false;

        if (state is EngagementLoaded) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            isLiked = state.engagement.isLikedBy(userId);
          }
        }

        // Use real-time data from stream
        final displayLiked = isLiked;

        return OutlinedButton.icon(
          onPressed: _isLoading ? null : () => _handleLikeTap(isLiked),
          icon: _isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      displayLiked
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary,
                    ),
                  ),
                )
              : Icon(
                  displayLiked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_outlined,
                  size: 20,
                  color: displayLiked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
          label: Text(displayLiked ? 'Liked' : 'Like'),
          style: OutlinedButton.styleFrom(
            foregroundColor: displayLiked
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            side: BorderSide(
              color: displayLiked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
        );
      },
    );
  }

  void _handleLikeTap(bool currentlyLiked) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _isLoading) return;

    // Simple loading state only
    setState(() {
      _isLoading = true;
    });

    try {
      // Database call - real-time stream will update UI
      context.read<EngagementBloc>().add(ToggleLike(widget.blogId, userId));

      // Reset loading after short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
