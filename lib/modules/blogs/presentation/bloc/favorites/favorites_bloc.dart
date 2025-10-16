import 'dart:async';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/features/favourite_blogs/data/models/favorite.dart';
import 'package:blog_app/modules/blogs/data/services/firestore_favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FirestoreFavoritesService _favoritesService =
      FirestoreFavoritesService();
  StreamSubscription? _favoritesSubscription;

  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadUserFavorites>(onLoadUserFavorites);
    on<ToggleFavorite>(onToggleFavorite);
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }

  void onLoadUserFavorites(
    LoadUserFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    try {
      await _favoritesSubscription?.cancel();

      // Get favorites and favorite blogs in parallel
      final favorites = await _favoritesService.getUserFavorites(event.userId);
      final favoriteBlogs = await _favoritesService.getUserFavoriteBlogs(
        event.userId,
      );

      if (!isClosed) {
        emit(FavoritesLoaded(favorites, favoriteBlogs));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FavoritesError(e.toString()));
      }
    }
  }

  void onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.toggleFavorite(event.userId, event.blogId);

      // Reload both favorites and favorite blogs
      final favorites = await _favoritesService.getUserFavorites(event.userId);
      final favoriteBlogs = await _favoritesService.getUserFavoriteBlogs(
        event.userId,
      );
      emit(FavoritesLoaded(favorites, favoriteBlogs));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // Helper method to get current user ID
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  // Helper method to check if a blog is favorited
  bool isBlogFavorited(String blogId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.isFavorited(blogId);
    }
    return false;
  }
}
