import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class DeleteBlogUseCase extends UseCase<Future<void>, DeleteBlogUseCaseParams> {
  DeleteBlogUseCase(this._blogCrudRepository);

  final BlogCrudRepository _blogCrudRepository;

  @override
  Future<void> execute(DeleteBlogUseCaseParams params) async {
    return await _blogCrudRepository.deleteBlog(params.blogId);
  }
}

class DeleteBlogUseCaseParams extends Equatable {
  const DeleteBlogUseCaseParams({required this.blogId});
  final String blogId;

  @override
  List<Object?> get props => [blogId];
}
