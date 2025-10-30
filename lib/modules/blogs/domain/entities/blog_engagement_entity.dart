import 'blog_comment_entity.dart';

class BlogEngagementEntity {
  final String blogId;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final Map<String, bool> likes;
  final List<BlogCommentEntity> comments;
  final Map<String, DateTime> views;

  BlogEngagementEntity({
    required this.blogId,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.likes,
    required this.comments,
    required this.views,
  });
}
