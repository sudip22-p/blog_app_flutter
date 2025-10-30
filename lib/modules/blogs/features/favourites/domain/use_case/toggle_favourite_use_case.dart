import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class ToggleFavouriteUseCaseUseCase
    extends UseCase<Future<bool>, ToggleFavouriteUseCaseUseCaseParams> {
  ToggleFavouriteUseCaseUseCase(this._favouriteRepository);

  final FavouriteRepository _favouriteRepository;

  @override
  Future<bool> execute(ToggleFavouriteUseCaseUseCaseParams params) async {
    return await _favouriteRepository.toggleFavorite(
      params.userId,
      params.blogId,
    );
  }
}

class ToggleFavouriteUseCaseUseCaseParams extends Equatable {
  const ToggleFavouriteUseCaseUseCaseParams({
    required this.userId,
    required this.blogId,
  });
  final String userId;
  final String blogId;

  @override
  List<Object?> get props => [userId, blogId];
}
