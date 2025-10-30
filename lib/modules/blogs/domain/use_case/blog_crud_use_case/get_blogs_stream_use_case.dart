import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class GetBlogsStreamUseCase
    extends UseCase<Stream<List<BlogEntity>>, NoParams> {
  GetBlogsStreamUseCase(this._blogCrudRepository);

  final BlogCrudRepository _blogCrudRepository;

  @override
  Future<Stream<List<BlogEntity>>> execute(NoParams params) async {
    return _blogCrudRepository.getBlogsStream();
  }
}
