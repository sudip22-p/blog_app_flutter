part of "auth_bloc.dart";

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignUpSuccess extends AuthState {
  final String message;

  const AuthSignUpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

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

class AuthProfileUpdated extends AuthState {
  final String message;

  const AuthProfileUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthProfileLoaded extends AuthState {
  final Map<String, dynamic> profile;

  const AuthProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}
