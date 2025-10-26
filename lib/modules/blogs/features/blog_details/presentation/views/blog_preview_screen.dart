import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
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
    // add view in one call
    _addViewIfNeeded();
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

  void _shareContent() {
    final shareText =
        'Check out this amazing blog post: "${widget.blog.title}" by ${widget.blog.authorName}. \n ${widget.blog.content}';
    Clipboard.setData(ClipboardData(text: shareText));
    CustomSnackbar.showToastMessage(
      type: ToastType.success,
      message: "Content copied to clipboard!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.surface,
      appBar: CustomAppBarWidget(
        title: Text(
          "Blog Details",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        backgroundColor: context.customTheme.background,
        showBackButton: true,
        actions: [
          FavouriteToggle(blog: widget.blog),

          IconButton(onPressed: _shareContent, icon: const Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          PreviewBlogContent(blog: widget.blog),

          PreviewCommentTopSection(
            blog: widget.blog,
            commentController: _commentController,
          ),

          PreviewCommentList(blog: widget.blog),

          SliverToBoxAdapter(child: AppGaps.gapH16),
        ],
      ),
    );
  }
}
