import 'package:blog_app/features/blogs/data/models/favorite.dart';
import 'package:equatable/equatable.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;
  final Set<String> favoriteBlogIds;

  FavoritesLoaded(this.favorites)
    : favoriteBlogIds = favorites.map((f) => f.blogId).toSet();

  @override
  List<Object?> get props => [favorites];

  bool isFavorited(String blogId) => favoriteBlogIds.contains(blogId);
}

class FavoritesOperationSuccess extends FavoritesState {
  final String message;
  final bool isFavorited;

  FavoritesOperationSuccess(this.message, this.isFavorited);

  @override
  List<Object?> get props => [message, isFavorited];
}

class FavoritesOperationFailure extends FavoritesState {
  final String error;

  FavoritesOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
