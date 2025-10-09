import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/features/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:blog_app/features/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:blog_app/features/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const BlogCard({
    super.key,
    required this.blog,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () => _navigateToBlogPreview(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CoverImageSection(blog: blog, theme: theme),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TagsSection(tags: blog.tags, theme: theme),
                    if (blog.tags.isNotEmpty) const SizedBox(height: 8),
                    _BlogTitle(title: blog.title, theme: theme),
                    const SizedBox(height: 6),
                    _BlogContent(content: blog.content, theme: theme),
                    const SizedBox(height: 12),
                    _AuthorSection(blog: blog, theme: theme),
                    const SizedBox(height: 12),
                    _BlogStats(blog: blog, theme: theme),
                    if (showActions) ...[
                      const SizedBox(height: 12),
                      _ActionButtons(
                        onEdit: onEdit,
                        onDelete: onDelete,
                        theme: theme,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBlogPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }
}

class _CoverImageSection extends StatefulWidget {
  final Blog blog;
  final ThemeData theme;

  const _CoverImageSection({required this.blog, required this.theme});

  @override
  State<_CoverImageSection> createState() => _CoverImageSectionState();
}

class _CoverImageSectionState extends State<_CoverImageSection> {
  bool? _localFavoriteState; // For instant UI feedback
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ensureFavoritesLoaded();
  }

  void _ensureFavoritesLoaded() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Use addPostFrameCallback to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final favoritesBloc = context.read<FavoritesBloc>();
          // Only load if we're in initial state
          if (favoritesBloc.state is FavoritesInitial) {
            favoritesBloc.add(LoadUserFavorites(userId));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (widget.blog.coverImageUrl == null) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              widget.blog.coverImageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: widget.theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: widget.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: widget.theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
          // Simple favorite button
          Positioned(
            top: 8,
            right: 8,
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                // Use local state for instant feedback, fallback to bloc state
                bool isFavorite =
                    _localFavoriteState ??
                    (state is FavoritesLoaded
                        ? state.isFavorited(widget.blog.id)
                        : false);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleFavoriteTap(userId, isFavorite),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isFavorite
                                        ? Colors.red
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              )
                            : Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.red
                                    : Colors.grey.shade600,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleFavoriteTap(String? userId, bool currentlyFavorite) async {
    if (userId == null || _isLoading) return;

    // Instant UI update
    setState(() {
      _localFavoriteState = !currentlyFavorite;
      _isLoading = true;
    });

    try {
      // Simple database call
      context.read<FavoritesBloc>().add(ToggleFavorite(userId, widget.blog.id));

      // Reset after short delay
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _localFavoriteState = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _localFavoriteState = currentlyFavorite;
          _isLoading = false;
        });
      }
    }
  }
}

class _TagsSection extends StatelessWidget {
  final List<String> tags;
  final ThemeData theme;

  const _TagsSection({required this.tags, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BlogTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _BlogTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _BlogContent extends StatelessWidget {
  final String content;
  final ThemeData theme;

  const _BlogContent({required this.content, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.4,
        fontSize: 14,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _AuthorSection extends StatelessWidget {
  final Blog blog;
  final ThemeData theme;

  const _AuthorSection({required this.blog, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              blog.authorName.isNotEmpty
                  ? blog.authorName[0].toUpperCase()
                  : 'A',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.authorName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatTimeAgo(blog.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _BlogStats extends StatefulWidget {
  final Blog blog;
  final ThemeData theme;

  const _BlogStats({required this.blog, required this.theme});

  @override
  State<_BlogStats> createState() => _BlogStatsState();
}

class _BlogStatsState extends State<_BlogStats> {
  bool _isLiking = false;
  BlogEngagement? _engagement;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEngagement();
  }

  Future<void> _loadEngagement() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = RealtimeDatabaseEngagementService();
      final engagement = await service.getBlogEngagement(widget.blog.id);
      if (mounted) {
        setState(() {
          _engagement = engagement;
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

  @override
  Widget build(BuildContext context) {
    // Use local state instead of BLoC for simple display
    final likeCount = _engagement?.likesCount ?? 0;
    final viewCount = _engagement?.viewsCount ?? 0;
    final commentCount = _engagement?.commentsCount ?? 0;

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.theme.colorScheme.outline.withValues(alpha: 0.1),
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
                  widget.theme.colorScheme.primary,
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
        color: widget.theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            icon: Icons.favorite_rounded,
            count: likeCount,
            color: Colors.red.shade400,
            theme: widget.theme,
            isLoading: _isLiking,
            onTap: () => _handleLikeTap(),
          ),
          _StatItem(
            icon: Icons.visibility_rounded,
            count: viewCount,
            color: widget.theme.colorScheme.primary,
            theme: widget.theme,
            isLoading: false,
          ),
          _StatItem(
            icon: Icons.chat_bubble_rounded,
            count: commentCount,
            color: widget.theme.colorScheme.onSurfaceVariant,
            theme: widget.theme,
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void _handleLikeTap() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _isLiking) return;

    // Simple loading state
    setState(() {
      _isLiking = true;
    });

    try {
      // Direct database call
      final service = RealtimeDatabaseEngagementService();
      await service.toggleLike(widget.blog.id, userId);

      // Reload engagement data to get updated counts
      await _loadEngagement();

      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final ThemeData theme;
  final VoidCallback? onTap;
  final bool isLoading;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.color,
    required this.theme,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            : Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(padding: const EdgeInsets.all(4), child: content),
        ),
      );
    }

    return content;
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ThemeData theme;

  const _ActionButtons({
    required this.onEdit,
    required this.onDelete,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
            ),
          ),
        if (onEdit != null && onDelete != null) const SizedBox(width: 8),
        if (onDelete != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
            ),
          ),
      ],
    );
  }
}
