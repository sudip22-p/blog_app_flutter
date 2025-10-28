import 'dart:async';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    //AUTHENTICATION EVENTS
    on<AuthSignInRequested>(onAuthSignInRequested);
    on<AuthSignUpRequested>(onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(onAuthSignOutRequested);

    //PROFILE EVENTS
    on<AuthUpdateDisplayNameRequested>(onAuthUpdateDisplayNameRequested);
    on<AuthUpdateProfilePictureRequested>(onAuthUpdateProfilePictureRequested);
    on<AuthLoadProfileRequested>(onAuthLoadProfileRequested);

    //ACCOUNT EVENTS
    on<AuthSendEmailVerificationRequested>(
      onAuthSendEmailVerificationRequested,
    );
    on<AuthSendPasswordResetRequested>(onAuthSendPasswordResetRequested);
    on<AuthDeleteAccountRequested>(onAuthDeleteAccountRequested);
  }

  //AUTHENTICATION HANDLERS
  Future<void> onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final signInUseCase = SignInWithEmailAndPasswordUseCase(_authRepository);
      final userCredential = await signInUseCase.execute(
        SignInWithEmailAndPasswordUseCaseParams(
          email: event.email,
          password: event.password,
        ),
      );
      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Sign in failed.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final signUpUseCase = CreateUserWithEmailAndPasswordUseCase(
        _authRepository,
      );
      final userCredential = await signUpUseCase.execute(
        CreateUserWithEmailAndPasswordUseCaseParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      if (userCredential?.user != null) {
        // Send email verification after successful signup
        try {
          final sendEmailVerificationUseCase = SendEmailVerificationUseCase(
            _authRepository,
          );
          await sendEmailVerificationUseCase.execute(NoParams());
          emit(
            const AuthSignUpSuccess(
              message:
                  'Account created successfully! Please check your email to verify your account.',
            ),
          );
        } catch (verificationError) {
          emit(AuthError(message: verificationError.toString()));
        }
      } else {
        emit(
          const AuthError(
            message: 'Account creation failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final signInWithGoogleUseCase = SignInWithGoogleUseCase(_authRepository);
      final userCredential = await signInWithGoogleUseCase.execute(NoParams());
      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Google sign-in was cancelled.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final signOutUseCase = SignOutUseCase(_authRepository);
      await signOutUseCase.execute(NoParams());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  //PROFILE HANDLERS
  Future<void> onAuthUpdateDisplayNameRequested(
    AuthUpdateDisplayNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final updateDisplayNameUseCase = UpdateDisplayNameUseCase(
        _authRepository,
      );
      await updateDisplayNameUseCase.execute(
        UpdateDisplayNameUseCaseParams(displayName: event.displayName),
      );
      emit(const AuthProfileUpdated(message: 'Profile updated successfully!'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthUpdateProfilePictureRequested(
    AuthUpdateProfilePictureRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final updateProfilePictureUseCase = UpdateProfilePictureUseCase(
        _authRepository,
      );
      await updateProfilePictureUseCase.execute(NoParams());
      emit(
        const AuthProfileUpdated(
          message: 'Profile picture updated successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthLoadProfileRequested(
    AuthLoadProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const AuthError(message: 'User not authenticated'));
        return;
      }
    }
    emit(AuthLoading());
    try {
      final getCurrentUserProfileUseCase = GetCurrentUserProfileUseCase(
        _authRepository,
      );
      final profile = await getCurrentUserProfileUseCase.execute(NoParams());
      if (profile.uid != '') {
        emit(AuthProfileLoaded(profile: profile));
      } else {
        emit(const AuthError(message: 'Failed to load user profile'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  //ACCOUNT HANDLERS
  Future<void> onAuthSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final sendEmailVerificationUseCase = SendEmailVerificationUseCase(
        _authRepository,
      );
      await sendEmailVerificationUseCase.execute(NoParams());
      emit(
        const AuthEmailVerificationSent(
          message: 'Verification email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthSendPasswordResetRequested(
    AuthSendPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final sendPasswordResetEmailUseCase = SendPasswordResetEmailUseCase(
        _authRepository,
      );
      await sendPasswordResetEmailUseCase.execute(
        SendPasswordResetEmailUseCaseParams(email: event.email),
      );
      emit(
        const AuthPasswordResetSent(
          message: 'Password reset email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final deleteAccountUseCase = DeleteAccountUseCase(_authRepository);
      await deleteAccountUseCase.execute(NoParams());
      // Remove the Firebase instance user too.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      emit(const AuthAccountDeleted(message: 'Account deleted successfully.'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
