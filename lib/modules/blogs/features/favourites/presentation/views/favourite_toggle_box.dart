import "package:blog_app/core/core.dart";
import "package:blog_app/modules/blogs/blogs.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class FavouriteToggle extends StatefulWidget {
  const FavouriteToggle({super.key, required this.blog});
  final BlogEntity blog;
  @override
  State<FavouriteToggle> createState() => _FavouriteToggleState();
}

class _FavouriteToggleState extends State<FavouriteToggle> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void handleFavoriteTap(String? userId, bool currentlyFavorite) async {
    if (userId == null || isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      context.read<FavoritesBloc>().add(
        ToggleFavorite(userId, widget.blog.id!),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          CustomSnackbar.showToastMessage(
            message: state.error,
            type: ToastType.error,
          );
          setState(() {
            isLoading = false;
          });
        } else if (state is FavoritesLoaded) {
          setState(() {
            isLoading = false;
          });
        } else if (state is FavoritesInitial) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            context.read<FavoritesBloc>().add(LoadUserFavorites(userId));
          }
        }
      },
      builder: (context, state) {
        bool isFavorite = (state is FavoritesLoaded
            ? state.isFavorited(widget.blog.id!)
            : false);
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
