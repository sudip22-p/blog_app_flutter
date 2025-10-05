import 'package:blog_app/features/blogs/data/demo_blogs.dart';
import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blogs/presentation/widgets/bottom_nav_bar.dart';
import 'package:blog_app/features/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  // For demo purposes, we'll simulate some favorite blogs
  Set<String> favoriteBlogIds = {'1', '3'}; // Demo favorite IDs

  void _removeFavorite(String blogId) {
    setState(() {
      favoriteBlogIds.remove(blogId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from favorites'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              favoriteBlogIds.add(blogId);
            });
          },
        ),
      ),
    );
  }

  void _openBlog(Blog blog) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${blog.title}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Blog> get favoriteBlogs {
    return demoBlogs
        .where((blog) => favoriteBlogIds.contains(blog.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = favoriteBlogs;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Favorites',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          Chip(
            avatar: const Icon(Icons.favorite, size: 16),
            label: Text('${favorites.length}'),
            backgroundColor: Colors.pink.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: 'No Favorites Yet!',
              message:
                  'Start exploring amazing blogs and tap the heart icon to add them to your favorites collection.',
              buttonText: 'Explore Blogs',
              onButtonPressed: () => Navigator.pop(context),
            )
          : Column(
              children: [
                // Header info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.pink),
                      const SizedBox(width: 12),
                      Text(
                        'You have ${favorites.length} favorite blog${favorites.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorites list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final blog = favorites[index];
                      return Dismissible(
                        key: Key('favorite-${blog.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text(
                                'Remove',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (_) => _removeFavorite(blog.id),
                        child: BlogCard(
                          blog: blog,
                          isFavorite: true,
                          onFavoriteToggle: () => _removeFavorite(blog.id),
                          onTap: () => _openBlog(blog),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: const BottomNavBar(selection: 2),
    );
  }
}
