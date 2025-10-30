import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class GetBlogEngagementStreamUseCase
    extends UseCase<Stream<List<BlogEngagementEntity>>, NoParams> {
  GetBlogEngagementStreamUseCase(this._blogEngagementRepository);

  final BlogEngagementRepository _blogEngagementRepository;

  @override
  Future<Stream<List<BlogEngagementEntity>>> execute(NoParams params) async {
    return _blogEngagementRepository.getBlogEngagementStream();
  }
}
