import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoverImageSection extends StatefulWidget {
  final Blog blog;

  const CoverImageSection({super.key, required this.blog});

  @override
  State<CoverImageSection> createState() => CoverImageSectionState();
}

class CoverImageSectionState extends State<CoverImageSection> {
  bool? localFavoriteState;
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

  void handleFavoriteTap(String? userId, bool currentlyFavorite) async {
    if (userId == null || isLoading) return;
    setState(() {
      localFavoriteState = !currentlyFavorite;
      isLoading = true;
    });
    try {
      context.read<FavoritesBloc>().add(ToggleFavorite(userId, widget.blog.id));
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          localFavoriteState = null;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          localFavoriteState = currentlyFavorite;
          isLoading = false;
        });
      }
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
}
