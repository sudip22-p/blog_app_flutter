import 'dart:async';
import 'package:blog_app/features/blogs/data/services/firestore_favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FirestoreFavoritesService _favoritesService =
      FirestoreFavoritesService();
  StreamSubscription? _favoritesSubscription;

  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadUserFavorites>(_onLoadUserFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }

  void _onLoadUserFavorites(
    LoadUserFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    try {
      await _favoritesSubscription?.cancel();

      // Get initial data without stream to avoid emit issues
      final favorites = await _favoritesService.getUserFavorites(event.userId);
      if (!isClosed) {
        emit(FavoritesLoaded(favorites));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FavoritesOperationFailure(e.toString()));
      }
    }
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorited = await _favoritesService.toggleFavorite(
        event.userId,
        event.blogId,
      );
      emit(
        FavoritesOperationSuccess(
          isFavorited ? 'Added to favorites ❤️' : 'Removed from favorites',
          isFavorited,
        ),
      );

      // Reload favorites after toggle
      add(LoadUserFavorites(event.userId));
    } catch (e) {
      emit(FavoritesOperationFailure(e.toString()));
    }
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.addToFavorites(event.userId, event.blogId);
      emit(FavoritesOperationSuccess('Added to favorites ❤️', true));

      // Reload favorites after adding
      add(LoadUserFavorites(event.userId));
    } catch (e) {
      emit(FavoritesOperationFailure(e.toString()));
    }
  }

  void _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.removeFromFavorites(event.userId, event.blogId);
      emit(FavoritesOperationSuccess('Removed from favorites', false));

      // Reload favorites after removing
      add(LoadUserFavorites(event.userId));
    } catch (e) {
      emit(FavoritesOperationFailure(e.toString()));
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
