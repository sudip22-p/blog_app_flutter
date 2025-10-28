part of "profile_bloc.dart";

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

//PROFILE EVENTS
class ProfileUpdateDisplayNameRequested extends ProfileEvent {
  final String displayName;
  const ProfileUpdateDisplayNameRequested({required this.displayName});
  @override
  List<Object?> get props => [displayName];
}

class ProfileUpdatePictureRequested extends ProfileEvent {}

class ProfileLoadRequested extends ProfileEvent {}
