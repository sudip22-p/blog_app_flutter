import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogPreviewScreen extends StatefulWidget {
  final Blog blog;

  const BlogPreviewScreen({super.key, required this.blog});

  @override
  State<BlogPreviewScreen> createState() => _BlogPreviewScreenState();
}

class _BlogPreviewScreenState extends State<BlogPreviewScreen> {
  // Static data for demonstration
  late int _likeCount;
  late int _viewCount;
  late bool _isLiked;
  late bool _isBookmarked;

  // Static comments data
  final List<Comment> _comments = [
    Comment(
      id: '1',
      authorName: 'John Doe',
      authorAvatar: 'https://via.placeholder.com/40',
      content: 'Great article! Very insightful and well written.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 5,
    ),
    Comment(
      id: '2',
      authorName: 'Sarah Smith',
      authorAvatar: 'https://via.placeholder.com/40',
      content: 'Thanks for sharing this. I learned something new today!',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 3,
    ),
    Comment(
      id: '3',
      authorName: 'Mike Johnson',
      authorAvatar: 'https://via.placeholder.com/40',
      content:
          'Interesting perspective. I would love to see more content like this.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likes: 8,
    ),
  ];

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with static values based on blog ID
    _likeCount = (widget.blog.id.hashCode % 50) + 10;
    _viewCount = (widget.blog.id.hashCode % 1000) + 100;
    _isLiked = false;
    _isBookmarked = false;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likeCount--;
      } else {
        _likeCount++;
      }
      _isLiked = !_isLiked;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: 'You',
          authorAvatar: 'https://via.placeholder.com/40',
          content: _commentController.text.trim(),
          timestamp: DateTime.now(),
          likes: 0,
        ),
      );
    });

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
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? theme.colorScheme.primary : null,
            ),
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
                                widget.blog.authorName,
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

                      // Stats
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_viewCount views',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_likeCount likes',
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
                            '${_comments.length} comments',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
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
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _toggleLike,
                              icon: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: _isLiked ? Colors.red : null,
                              ),
                              label: Text(_isLiked ? 'Liked' : 'Like'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _isLiked
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                                side: BorderSide(
                                  color: _isLiked
                                      ? Colors.red
                                      : theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
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
                    child: Text(
                      'Comments (${_comments.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final comment = _comments[index];
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
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(comment.authorAvatar),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: Text(
                          comment.authorName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.authorName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTimeAgo(comment.timestamp),
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
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Toggle comment like
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        size: 14,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        comment.likes.toString(),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () {
                                    // Reply to comment
                                  },
                                  child: Text(
                                    'Reply',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: _comments.length),
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
