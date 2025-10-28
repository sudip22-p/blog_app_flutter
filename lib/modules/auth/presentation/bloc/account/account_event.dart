part of "account_bloc.dart";

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

//ACCOUNT EVENTS
class AccountSendEmailVerificationRequested extends AccountEvent {}

class AccountSendPasswordResetRequested extends AccountEvent {
  final String email;
  const AccountSendPasswordResetRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AccountDeleteRequested extends AccountEvent {}
