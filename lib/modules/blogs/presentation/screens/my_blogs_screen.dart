import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/screens/add_blog.dart';
import 'package:blog_app/modules/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:blog_app/modules/blogs/presentation/screens/update_blog.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/blog_card.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/empty_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void deleteBlog(Blog blog) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Blog'),
        content: Text('Are you sure you want to delete "${blog.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete blog using BlogBloc
              context.read<BlogBloc>().add(BlogDeleted(blog.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Blog "${blog.title}" deleted'),
                  backgroundColor: context.customTheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customTheme.error,
              foregroundColor: context.customTheme.contentPrimary,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void editBlog(Blog blog, List<Blog> allBlogs) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBlog(blogId: blog.id, blogs: allBlogs),
      ),
    );
  }

  void previewBlog(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }

  List<Blog> getMyBlogs(List<Blog> allBlogs) {
    if (currentUserId == null) return [];
    return allBlogs.where((blog) => blog.authorId == currentUserId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Blogs',
          style: TextStyle(color: context.customTheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBlog()),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Create New Blog',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          // Handle initial state and trigger blog loading
          if (state is BlogInitial) {
            context.read<BlogBloc>().add(BlogsLoaded());
            return const Center(child: CircularProgressIndicator());
          }

          // Handle loading state
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state is BlogOperationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.customTheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading blogs',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BlogBloc>().add(BlogsLoaded());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle success states
          List<Blog> allBlogs = [];
          if (state is BlogLoadSuccess) {
            allBlogs = state.blogs;
          } else if (state is BlogOperationSuccess) {
            allBlogs = state.blogs;
          }

          // Filter blogs for current user
          final myBlogsList = getMyBlogs(allBlogs);

          // Check if user is not logged in
          if (currentUserId == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    size: 64,
                    color: context.customTheme.secondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please log in to view your blogs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          return myBlogsList.isEmpty
              ? EmptyState(
                  icon: Icons.edit_note_outlined,
                  title: 'Start Your Writing Journey!',
                  message:
                      'You haven\'t created any blogs yet. Share your ideas and stories with the world.',
                  buttonText: 'Write Your First Blog',
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddBlog()),
                    );
                  },
                )
              : Column(
                  children: [
                    // Header info
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.customTheme.surface.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_stories),
                          const SizedBox(width: 12),
                          Text(
                            '${myBlogsList.length} blog${myBlogsList.length == 1 ? '' : 's'} published',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    // Blog list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: myBlogsList.length,
                        itemBuilder: (context, index) {
                          final blog = myBlogsList[index];
                          return BlogCard(
                            blog: blog,
                            showActions: true,
                            onEdit: () => editBlog(blog, allBlogs),
                            onDelete: () => deleteBlog(blog),
                            onTap: () => previewBlog(blog),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
