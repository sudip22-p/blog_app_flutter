import 'blog_comment_model.dart';

class BlogEngagementModel {
  final String blogId;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final Map<String, bool> likes;
  final List<BlogCommentModel> comments;
  final Map<String, DateTime> views;

  BlogEngagementModel({
    required this.blogId,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.likes,
    required this.comments,
    required this.views,
  });
}
