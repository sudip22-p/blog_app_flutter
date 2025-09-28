import 'package:blog_app/features/blogs/data/demo_blogs.dart';
import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class BlogsHome extends StatefulWidget {
  const BlogsHome({super.key});

  @override
  State<BlogsHome> createState() => _BlogsHomeState();
}

class _BlogsHomeState extends State<BlogsHome> {
  Set<String> favoriteBlogIds = {}; // Store favorite blog IDs

  void _toggleFavorite(String blogId) {
    setState(() {
      if (favoriteBlogIds.contains(blogId)) {
        favoriteBlogIds.remove(blogId);
        _showSnackBar('Removed from favorites', Colors.orange);
      } else {
        favoriteBlogIds.add(blogId);
        _showSnackBar('Added to favorites ❤️', Colors.pink);
      }
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openBlog(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (demoBlogs.isEmpty) {
      return EmptyState(
        icon: Icons.article_outlined,
        title: 'Welcome to Blog App !',
        message:
            'Start creating amazing content and share your thoughts with the world.',
        buttonText: 'Create Your First Post',
        onButtonPressed: () {
          _showSnackBar(
            'Blog creation feature coming soon!',
            Theme.of(context).colorScheme.primary,
          );
        },
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.trending_up),
              const SizedBox(width: 8),
              Text(
                'Trending Blogs',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Blog list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: demoBlogs.length,
            itemBuilder: (context, index) {
              final blog = demoBlogs[index];
              return BlogCard(
                blog: blog,
                isFavorite: favoriteBlogIds.contains(blog.id),
                onFavoriteToggle: () => _toggleFavorite(blog.id),
                onTap: () => _openBlog(blog),
              );
            },
          ),
        ),
      ],
    );
  }
}
