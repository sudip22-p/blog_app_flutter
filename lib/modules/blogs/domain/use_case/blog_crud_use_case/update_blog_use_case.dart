import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class UpdateBlogUseCase extends UseCase<Future<void>, UpdateBlogUseCaseParams> {
  UpdateBlogUseCase(this._blogCrudRepository);

  final BlogCrudRepository _blogCrudRepository;

  @override
  Future<void> execute(UpdateBlogUseCaseParams params) async {
    return await _blogCrudRepository.updateBlog(params.blog);
  }
}

class UpdateBlogUseCaseParams extends Equatable {
  const UpdateBlogUseCaseParams({required this.blog});
  final BlogEntity blog;

  @override
  List<Object?> get props => [blog];
}
