part of "profile_bloc.dart";

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final String message;
  const ProfileUpdated({required this.message});
  @override
  List<Object?> get props => [message];
}

class ProfileLoaded extends ProfileState {
  final UserProfileEntity profile;
  const ProfileLoaded({required this.profile});
  @override
  List<Object?> get props => [profile];
}
