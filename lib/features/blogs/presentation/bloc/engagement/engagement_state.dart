import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:equatable/equatable.dart';

abstract class EngagementState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EngagementInitial extends EngagementState {}

class EngagementLoading extends EngagementState {}

class EngagementLoaded extends EngagementState {
  final BlogEngagement engagement;

  EngagementLoaded(this.engagement);

  @override
  List<Object?> get props => [engagement];
}

class EngagementOperationSuccess extends EngagementState {
  final String message;
  final BlogEngagement? engagement;

  EngagementOperationSuccess(this.message, [this.engagement]);

  @override
  List<Object?> get props => [message, engagement];
}

class EngagementOperationFailure extends EngagementState {
  final String error;

  EngagementOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Multi-blog engagement state for blog lists
class MultiBlogEngagementLoaded extends EngagementState {
  final Map<String, BlogEngagement> engagements;

  MultiBlogEngagementLoaded(this.engagements);

  @override
  List<Object?> get props => [engagements];

  BlogEngagement? getEngagement(String blogId) => engagements[blogId];
}
