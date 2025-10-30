import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';

@injectable
class GetBlogEngagementUseCase
    extends
        UseCase<List<BlogEngagementEntity>, GetBlogEngagementUseCaseParams> {
  GetBlogEngagementUseCase(this._blogEngagementRepository);

  final BlogEngagementRepository _blogEngagementRepository;

  @override
  Future<List<BlogEngagementEntity>> execute(
    GetBlogEngagementUseCaseParams params,
  ) async {
    return _blogEngagementRepository.getBlogEngagement(params.blogId);
  }
}

class GetBlogEngagementUseCaseParams extends Equatable {
  const GetBlogEngagementUseCaseParams({required this.blogId});
  final String blogId;

  @override
  List<Object?> get props => [blogId];
}
