part of 'blog_engagement_bloc.dart';

abstract class EngagementEvent {}

class LoadBlogEngagement extends EngagementEvent {
  final String blogId;
  LoadBlogEngagement(this.blogId);
}

class StartBlogEngagementStream extends EngagementEvent {
  StartBlogEngagementStream();
}

class EngagementStreamUpdate extends EngagementEvent {
  final List<BlogEngagementEntity> engagements;
  EngagementStreamUpdate(this.engagements);
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
  final BlogCommentEntity comment;
  AddComment(this.blogId, this.comment);
}
