import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class AddCommentUseCase extends UseCase<Future<void>, AddCommentUseCaseParams> {
  AddCommentUseCase(this._blogEngagementRepository);

  final BlogEngagementRepository _blogEngagementRepository;

  @override
  Future<void> execute(AddCommentUseCaseParams params) async {
    return _blogEngagementRepository.addComment(params.blogId, params.comment);
  }
}

class AddCommentUseCaseParams extends Equatable {
  const AddCommentUseCaseParams({required this.blogId, required this.comment});
  final String blogId;
  final BlogCommentEntity comment;

  @override
  List<Object?> get props => [blogId, comment];
}
