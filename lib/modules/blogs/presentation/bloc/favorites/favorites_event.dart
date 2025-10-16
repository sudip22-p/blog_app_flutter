part of 'favorites_bloc.dart';
abstract class FavoritesEvent {}

class LoadUserFavorites extends FavoritesEvent {
  final String userId;
  LoadUserFavorites(this.userId);
}

class ToggleFavorite extends FavoritesEvent {
  final String userId;
  final String blogId;
  ToggleFavorite(this.userId, this.blogId);
}
