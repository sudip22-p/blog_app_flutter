import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class AddBlogUseCase extends UseCase<Future<void>, AddBlogUseCaseParams> {
  AddBlogUseCase(this._blogCrudRepository);

  final BlogCrudRepository _blogCrudRepository;

  @override
  Future<void> execute(AddBlogUseCaseParams params) async {
    return await _blogCrudRepository.addBlog(params.blog);
  }
}

class AddBlogUseCaseParams extends Equatable {
  const AddBlogUseCaseParams({required this.blog});
  final BlogEntity blog;

  @override
  List<Object?> get props => [blog];
}
