import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';

abstract class EngagementEvent {}

class LoadBlogEngagement extends EngagementEvent {
  final String blogId;
  LoadBlogEngagement(this.blogId);
}

class ToggleLike extends EngagementEvent {
  final String blogId;
  final String userId;
  ToggleLike(this.blogId, this.userId);
}

class AddView extends EngagementEvent {
  final String blogId;
  final String userId;
  AddView(this.blogId, this.userId);
}

class AddComment extends EngagementEvent {
  final String blogId;
  final BlogComment comment;
  AddComment(this.blogId, this.comment);
}

class DeleteComment extends EngagementEvent {
  final String blogId;
  final String commentId;
  DeleteComment(this.blogId, this.commentId);
}

class ToggleCommentLike extends EngagementEvent {
  final String blogId;
  final String commentId;
  final String userId;
  ToggleCommentLike(this.blogId, this.commentId, this.userId);
}

class LoadMultipleBlogEngagements extends EngagementEvent {
  final List<String> blogIds;
  LoadMultipleBlogEngagements(this.blogIds);
}

class InitializeBlogEngagement extends EngagementEvent {
  final String blogId;
  InitializeBlogEngagement(this.blogId);
}
