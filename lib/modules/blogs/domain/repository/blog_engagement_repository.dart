import 'package:blog_app/modules/blogs/blogs.dart';

abstract class BlogEngagementRepository {
  Stream<List<BlogEngagementEntity>> getBlogEngagementStream();

  Future<List<BlogEngagementEntity>> getBlogEngagement(String blogId);

  Future<void> toggleLike(String blogId, String userId);

  Future<void> addView(String blogId, String userId);

  Future<void> addComment(String blogId, BlogCommentEntity comment);
}
