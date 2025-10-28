part of "auth_bloc.dart";

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//COMMON STATES
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

//AUTHENTICATION STATES
//for signin with email-password & continue with google
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

//for signup with email-password
class AuthSignUpSuccess extends AuthState {
  final String message;
  const AuthSignUpSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

//ACCOUNT STATES
class AuthPasswordResetSent extends AuthState {
  final String message;
  const AuthPasswordResetSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthEmailVerificationSent extends AuthState {
  final String message;
  const AuthEmailVerificationSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthAccountDeleted extends AuthState {
  final String message;
  const AuthAccountDeleted({required this.message});
  @override
  List<Object?> get props => [message];
}

//PROFILE STATES
class AuthProfileUpdated extends AuthState {
  final String message;
  const AuthProfileUpdated({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthProfileLoaded extends AuthState {
  final UserProfileEntity profile;
  const AuthProfileLoaded({required this.profile});
  @override
  List<Object?> get props => [profile];
}
