import 'package:blog_app/features/blogs/data/demo_blogs.dart';
import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:blog_app/features/blogs/presentation/widgets/bottom_nav_bar.dart';
import 'package:blog_app/features/blogs/presentation/widgets/empty_state.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  // For demo, assume current user is 'u101' (Sudip Paudel)
  final String currentUserId = 'u101';

  void _deleteBlog(Blog blog) {
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
              setState(() {
                demoBlogs.removeWhere((b) => b.id == blog.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Blog "${blog.title}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editBlog(Blog blog) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening editor for "${blog.title}"...')),
    );
  }

  void _previewBlog(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }

  List<Blog> get myBlogs {
    return demoBlogs.where((blog) => blog.authorId == currentUserId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myBlogsList = myBlogs;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Blogs',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening blog editor...')),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Create New Blog',
          ),
          Chip(
            avatar: const Icon(Icons.article, size: 16),
            label: Text('${myBlogsList.length}'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: myBlogsList.isEmpty
          ? EmptyState(
              icon: Icons.edit_note_outlined,
              title: 'Start Your Writing Journey!',
              message:
                  'You haven\'t created any blogs yet. Share your ideas and stories with the world.',
              buttonText: 'Write Your First Blog',
              onButtonPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Blog editor coming soon!')),
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
                    color: theme.colorScheme.primaryContainer.withValues(
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
                        showFavoriteButton: false,
                        showActions: true,
                        onEdit: () => _editBlog(blog),
                        onDelete: () => _deleteBlog(blog),
                        onTap: () => _previewBlog(blog),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: BottomNavBar(selection: 3),
    );
  }
}
