part of 'favourites_bloc.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavouriteEntity> favorites;
  final List<BlogEntity> favoriteBlogs;
  final Set<String> favoriteBlogIds;

  FavoritesLoaded(this.favorites, this.favoriteBlogs)
    : favoriteBlogIds = favorites.map((f) => f.blogId).toSet();

  @override
  List<Object?> get props => [favorites, favoriteBlogs];

  bool isFavorited(String blogId) => favoriteBlogIds.contains(blogId);
}

class FavoritesError extends FavoritesState {
  final String error;

  FavoritesError(this.error);

  @override
  List<Object?> get props => [error];
}
