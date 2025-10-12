import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:blog_app/features/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:blog_app/features/blogs/presentation/widgets/preview_blog_content.dart';
import 'package:blog_app/features/blogs/presentation/widgets/preview_comment_list.dart';
import 'package:blog_app/features/blogs/presentation/widgets/preview_comment_top_section.dart';
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

  void _shareContent() {
    final shareText =
        'Check out this amazing blog post: "${widget.blog.title}" by ${widget.blog.authorName}. \n ${widget.blog.content}';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
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
          PreviewBlogContent(blog: widget.blog, theme: theme),

          // Comments section
          PreviewCommentTopSection(
            theme: theme,
            blog: widget.blog,
            commentController: _commentController,
          ),

          // Comments list
          PreviewCommentList(theme: theme),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
