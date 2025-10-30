import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class GetUserFavouriteBlogsUseCase
    extends
        UseCase<Future<List<BlogEntity>>, GetUserFavouriteBlogsUseCaseParams> {
  GetUserFavouriteBlogsUseCase(this._favouriteRepository);

  final FavouriteRepository _favouriteRepository;

  @override
  Future<List<BlogEntity>> execute(
    GetUserFavouriteBlogsUseCaseParams params,
  ) async {
    return await _favouriteRepository.getUserFavoriteBlogs(params.userId);
  }
}

class GetUserFavouriteBlogsUseCaseParams extends Equatable {
  const GetUserFavouriteBlogsUseCaseParams({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}
