import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/views/explore_blogs_screen.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/view/blog_card.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<FavoritesBloc>().add(LoadUserFavorites(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Favorites'),
        titleTextStyle: context.textTheme.titleLarge?.copyWith(
          color: context.customTheme.primary,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final count = state is FavoritesLoaded
                  ? state.favoriteBlogs.length
                  : 0;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                constraints: const BoxConstraints(
                  maxWidth: 80,
                ), // Prevent overflow
                child: Chip(
                  avatar: const Icon(Icons.favorite, size: 14),
                  label: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: context.customTheme.secondary.withValues(
                    alpha: 0.1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
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
                    'Failed to load favorites',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFavorites,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FavoritesLoaded) {
            final favoriteBlogs = state.favoriteBlogs;

            if (favoriteBlogs.isEmpty) {
              return EmptyState(
                icon: Icons.favorite_border,
                title: 'No Favorites Yet!',
                message:
                    'Start exploring amazing blogs and tap the heart icon to add them to your favorites collection.',
                buttonText: 'Explore Blogs',
                onButtonPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const ExploreBlogsScreen(),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: favoriteBlogs.length,
              itemBuilder: (context, index) {
                final blog = favoriteBlogs[index];
                return BlogCard(blog: blog);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
