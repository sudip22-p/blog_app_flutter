part of 'engagement_bloc.dart';

abstract class EngagementEvent {}

class LoadBlogEngagement extends EngagementEvent {
  final String blogId;
  LoadBlogEngagement(this.blogId);
}

class StartBlogEngagementStream extends EngagementEvent {
  final String blogId;
  StartBlogEngagementStream(this.blogId);
}

class EngagementStreamUpdate extends EngagementEvent {
  final BlogEngagement engagement;
  EngagementStreamUpdate(this.engagement);
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
