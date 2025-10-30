import 'dart:async';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/di/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  //ACCOUNT USECASES
  final SendEmailVerificationUseCase sendEmailVerificationUseCase =
      getIt<SendEmailVerificationUseCase>();
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase =
      getIt<SendPasswordResetEmailUseCase>();
  final DeleteAccountUseCase deleteAccountUseCase =
      getIt<DeleteAccountUseCase>();

  AccountBloc() : super(AccountInitial()) {
    //ACCOUNT EVENTS
    on<AccountSendEmailVerificationRequested>(
      onAccountSendEmailVerificationRequested,
    );
    on<AccountSendPasswordResetRequested>(onAccountSendPasswordResetRequested);
    on<AccountDeleteRequested>(onAccountDeleteAccountRequested);
  }

  //ACCOUNT HANDLERS
  Future<void> onAccountSendEmailVerificationRequested(
    AccountSendEmailVerificationRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await sendEmailVerificationUseCase.execute(NoParams());
      emit(
        const AccountEmailVerificationSent(
          message: 'Verification email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> onAccountSendPasswordResetRequested(
    AccountSendPasswordResetRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await sendPasswordResetEmailUseCase.execute(
        SendPasswordResetEmailUseCaseParams(email: event.email),
      );
      emit(
        const AccountPasswordResetSent(
          message: 'Password reset email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> onAccountDeleteAccountRequested(
    AccountDeleteRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await deleteAccountUseCase.execute(NoParams());
      // Remove the Firebase instance user too.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      emit(const AccountDeleted(message: 'Account deleted successfully.'));
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }
}
