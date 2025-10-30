import 'dart:async';
import 'package:blog_app/core/di/injection.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetUserFavouritesCollectionUseCase getUserFavouritesCollectionUseCase =
      getIt<GetUserFavouritesCollectionUseCase>();
  final GetUserFavouriteBlogsUseCase getUserFavouriteBlogsUseCase =
      getIt<GetUserFavouriteBlogsUseCase>();
  final ToggleFavouriteUseCaseUseCase toggleFavouriteUseCaseUseCase =
      getIt<ToggleFavouriteUseCaseUseCase>();

  StreamSubscription? _favoritesSubscription;

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }

  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadUserFavorites>(onLoadUserFavorites);
    on<ToggleFavorite>(onToggleFavorite);
  }

  void onLoadUserFavorites(
    LoadUserFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    try {
      await _favoritesSubscription?.cancel();
      final favorites = await getUserFavouritesCollectionUseCase.execute(
        GetUserFavouritesCollectionUseCaseParams(userId: event.userId),
      );
      final favoriteBlogs = await getUserFavouriteBlogsUseCase.execute(
        GetUserFavouriteBlogsUseCaseParams(userId: event.userId),
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
    emit(FavoritesLoading());
    try {
      await toggleFavouriteUseCaseUseCase.execute(
        ToggleFavouriteUseCaseUseCaseParams(
          userId: event.userId,
          blogId: event.blogId,
        ),
      );
      final favorites = await getUserFavouritesCollectionUseCase.execute(
        GetUserFavouritesCollectionUseCaseParams(userId: event.userId),
      );
      final favoriteBlogs = await getUserFavouriteBlogsUseCase.execute(
        GetUserFavouriteBlogsUseCaseParams(userId: event.userId),
      );
      emit(FavoritesLoaded(favorites, favoriteBlogs));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
