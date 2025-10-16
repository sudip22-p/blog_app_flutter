import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/data/models/blog_engagement.dart';
import 'package:blog_app/modules/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/screens/blog_preview_screen.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.customTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.customTheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.customTheme.outline.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ?? () => navigateToBlogPreview(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImageSection(blog: blog),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagsSection(tags: blog.tags),
                  if (blog.tags.isNotEmpty) const SizedBox(height: 8),
                  BlogTitle(title: blog.title),
                  const SizedBox(height: 6),
                  BlogContent(content: blog.content),
                  const SizedBox(height: 12),
                  AuthorSection(blog: blog),
                  const SizedBox(height: 12),
                  BlogStats(blog: blog),
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    ActionButtons(onEdit: onEdit, onDelete: onDelete),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToBlogPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }
}

class CoverImageSection extends StatefulWidget {
  final Blog blog;

  const CoverImageSection({super.key, required this.blog});

  @override
  State<CoverImageSection> createState() => CoverImageSectionState();
}

class CoverImageSectionState extends State<CoverImageSection> {
  bool? localFavoriteState; // For instant UI feedback
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ensureFavoritesLoaded();
  }

  void ensureFavoritesLoaded() {
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
                  color: context.customTheme.surface,
                  child: Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: context.customTheme.contentSurface,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: context.customTheme.surface,
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
          // favorite button
          Positioned(
            top: 8,
            right: 8,
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                //local state for instant feedback, fallback to bloc state
                bool isFavorite =
                    localFavoriteState ??
                    (state is FavoritesLoaded
                        ? state.isFavorited(widget.blog.id)
                        : false);

                return Container(
                  decoration: BoxDecoration(
                    color: context.customTheme.contentPrimary.withValues(
                      alpha: 0.9,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.customTheme.outline.withValues(
                          alpha: 0.1,
                        ),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () => handleFavoriteTap(userId, isFavorite),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isFavorite
                                        ? context.customTheme.error
                                        : context.customTheme.secondary,
                                  ),
                                ),
                              )
                            : Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? context.customTheme.error
                                    : context.customTheme.secondary,
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

  void handleFavoriteTap(String? userId, bool currentlyFavorite) async {
    if (userId == null || isLoading) return;

    // Instant UI update
    setState(() {
      localFavoriteState = !currentlyFavorite;
      isLoading = true;
    });

    try {
      context.read<FavoritesBloc>().add(ToggleFavorite(userId, widget.blog.id));

      // Reset after short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          localFavoriteState = null;
          isLoading = false;
        });
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          localFavoriteState = currentlyFavorite;
          isLoading = false;
        });
      }
    }
  }
}

class TagsSection extends StatelessWidget {
  final List<String> tags;

  const TagsSection({super.key, required this.tags});

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
            color: context.customTheme.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.customTheme.surface,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class BlogTitle extends StatelessWidget {
  final String title;

  const BlogTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class BlogContent extends StatelessWidget {
  final String content;

  const BlogContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.customTheme.contentSurface,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AuthorSection extends StatelessWidget {
  final Blog blog;

  const AuthorSection({super.key, required this.blog});

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
                context.customTheme.surface,
                context.customTheme.surface.withValues(alpha: 0.7),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              blog.authorName.isNotEmpty
                  ? blog.authorName[0].toUpperCase()
                  : 'A',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.customTheme.contentPrimary,
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
                blog.authorName == "" ? "Anonymous" : blog.authorName,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                formatTimeAgo(blog.createdAt),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.customTheme.contentSurface,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatTimeAgo(DateTime dateTime) {
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

class StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;

  const StatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
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
          formatCount(count),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.customTheme.contentSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return Material(
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(padding: const EdgeInsets.all(4), child: content),
        ),
      );
    }

    return content;
  }

  String formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
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
                foregroundColor: context.customTheme.error,
                side: BorderSide(color: context.customTheme.error),
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
