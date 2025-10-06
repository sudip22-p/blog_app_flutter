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

class AddToFavorites extends FavoritesEvent {
  final String userId;
  final String blogId;
  AddToFavorites(this.userId, this.blogId);
}

class RemoveFromFavorites extends FavoritesEvent {
  final String userId;
  final String blogId;
  RemoveFromFavorites(this.userId, this.blogId);
}
