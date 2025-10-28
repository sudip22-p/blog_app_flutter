part of "auth_bloc.dart";

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

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
