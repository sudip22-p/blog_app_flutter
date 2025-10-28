part of "account_bloc.dart";

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountError extends AccountState {
  final String message;
  const AccountError({required this.message});
  @override
  List<Object?> get props => [message];
}

class AccountPasswordResetSent extends AccountState {
  final String message;
  const AccountPasswordResetSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class AccountEmailVerificationSent extends AccountState {
  final String message;
  const AccountEmailVerificationSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class AccountDeleted extends AccountState {
  final String message;
  const AccountDeleted({required this.message});
  @override
  List<Object?> get props => [message];
}
