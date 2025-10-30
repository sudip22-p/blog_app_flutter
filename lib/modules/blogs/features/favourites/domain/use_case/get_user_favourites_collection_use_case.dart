import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class GetUserFavouritesCollectionUseCase
    extends
        UseCase<
          Future<List<FavouriteEntity>>,
          GetUserFavouritesCollectionUseCaseParams
        > {
  GetUserFavouritesCollectionUseCase(this._favouriteRepository);

  final FavouriteRepository _favouriteRepository;

  @override
  Future<List<FavouriteEntity>> execute(
    GetUserFavouritesCollectionUseCaseParams params,
  ) async {
    return await _favouriteRepository.getUserFavoritesCollection(params.userId);
  }
}

class GetUserFavouritesCollectionUseCaseParams extends Equatable {
  const GetUserFavouritesCollectionUseCaseParams({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}
