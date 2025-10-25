import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

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
      appBar: CustomAppBarWidget(
        title: Text(
          "Favorites",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),

        backgroundColor: context.customTheme.surface,

        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final count = state is FavoritesLoaded
                  ? state.favoriteBlogs.length
                  : '-';
              return Container(
                margin: EdgeInsets.only(right: AppSpacing.lg),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: context.customTheme.primary.withValues(alpha: 0.12),
                  borderRadius: AppBorderRadius.chipBorderRadius,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: AppSpacing.lg,
                      color: context.customTheme.error,
                    ),

                    AppGaps.gapW4,

                    Text(
                      '$count',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.customTheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              child: EmptyState(
                icon: Icons.error,
                title: 'Failed to Load Favorites',
                message: state.error,
                buttonText: 'Retry',
                onButtonPressed: _loadFavorites,
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
                onButtonPressed: () => {context.goNamed(Routes.dashboard.name)},
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
