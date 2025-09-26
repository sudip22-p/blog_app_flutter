part of "auth_bloc.dart";

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthSendEmailVerificationRequested extends AuthEvent {}

class AuthSendPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthSendPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthDeleteAccountRequested extends AuthEvent {}
