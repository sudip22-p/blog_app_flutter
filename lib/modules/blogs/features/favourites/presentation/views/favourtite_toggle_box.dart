import "package:blog_app/core/core.dart";
//TODO: edit.
import "package:blog_app/modules/blogs/data/models/blog.dart";
import "package:blog_app/modules/blogs/features/favourites/presentation/bloc/favorites_bloc.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class FavouriteToggle extends StatefulWidget {
  const FavouriteToggle({super.key, required this.blog});
  final Blog blog;
  @override
  State<FavouriteToggle> createState() => _FavouriteToggleState();
}

class _FavouriteToggleState extends State<FavouriteToggle> {
  bool? isFavouriteBlog;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFavourite();
  }

  void loadFavourite() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Use addPostFrameCallback to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final favoritesBloc = context.read<FavoritesBloc>();
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
      isFavouriteBlog = !currentlyFavorite;
      isLoading = true;
    });
    try {
      context.read<FavoritesBloc>().add(ToggleFavorite(userId, widget.blog.id));
    } catch (e) {
      if (mounted) {
        setState(() {
          isFavouriteBlog = currentlyFavorite;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFavorite =
            isFavouriteBlog ??
            (state is FavoritesLoaded
                ? state.isFavorited(widget.blog.id)
                : false);
        if (state is FavoritesLoaded) {
          isLoading = false;
        } else if (state is FavoritesError) {
          CustomSnackbar.showToastMessage(
            message: state.error,
            type: ToastType.error,
          );
          setState(() {
            isLoading = false;
            isFavouriteBlog = !isFavorite;
          });
        }
        return InkWell(
          onTap: () => handleFavoriteTap(userId, isFavorite),
          child: Container(
            decoration: BoxDecoration(
              color: context.customTheme.background,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: AppSpacing.xlg,
                      height: AppSpacing.xlg,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.xs,
                        color: context.customTheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: isFavorite
                        ? context.customTheme.error
                        : context.customTheme.contentBackground,
                    size: AppSpacing.xlg,
                  ),
          ),
        );
      },
    );
  }
}
