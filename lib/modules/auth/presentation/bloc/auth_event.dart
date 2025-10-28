part of "auth_bloc.dart";

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//AUTHENTICATION EVENTS
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
  final String name;
  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });
  @override
  List<Object?> get props => [email, password, name];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

//PROFILE EVENTS
class AuthUpdateDisplayNameRequested extends AuthEvent {
  final String displayName;
  const AuthUpdateDisplayNameRequested({required this.displayName});
  @override
  List<Object?> get props => [displayName];
}

class AuthUpdateProfilePictureRequested extends AuthEvent {}

class AuthLoadProfileRequested extends AuthEvent {}

//ACCOUNT EVENTS
class AuthSendEmailVerificationRequested extends AuthEvent {}

class AuthSendPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthSendPasswordResetRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthDeleteAccountRequested extends AuthEvent {}
