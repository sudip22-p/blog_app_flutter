import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class ToggleLikeUseCase extends UseCase<Future<void>, ToggleLikeUseCaseParams> {
  ToggleLikeUseCase(this._blogEngagementRepository);

  final BlogEngagementRepository _blogEngagementRepository;

  @override
  Future<void> execute(ToggleLikeUseCaseParams params) async {
    return _blogEngagementRepository.toggleLike(params.blogId, params.userId);
  }
}

class ToggleLikeUseCaseParams extends Equatable {
  const ToggleLikeUseCaseParams({required this.blogId, required this.userId});
  final String blogId;
  final String userId;

  @override
  List<Object?> get props => [blogId, userId];
}
