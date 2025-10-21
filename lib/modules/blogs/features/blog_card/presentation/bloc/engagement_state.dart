part of 'engagement_bloc.dart';

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

class EngagementError extends EngagementState {
  final String error;

  EngagementError(this.error);

  @override
  List<Object?> get props => [error];
}
