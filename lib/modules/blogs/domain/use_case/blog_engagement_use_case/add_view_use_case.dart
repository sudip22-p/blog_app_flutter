import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class AddViewUseCase extends UseCase<Future<void>, AddViewUseCaseParams> {
  AddViewUseCase(this._blogEngagementRepository);

  final BlogEngagementRepository _blogEngagementRepository;

  @override
  Future<void> execute(AddViewUseCaseParams params) async {
    return _blogEngagementRepository.addView(params.blogId, params.userId);
  }
}

class AddViewUseCaseParams extends Equatable {
  const AddViewUseCaseParams({required this.blogId, required this.userId});
  final String blogId;
  final String userId;

  @override
  List<Object?> get props => [blogId, userId];
}
