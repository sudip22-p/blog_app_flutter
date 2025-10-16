import 'dart:async';
import 'package:blog_app/modules/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({AuthService? authService})
    : authService = authService ?? AuthService(),
      super(AuthInitial()) {
    on<AuthSignInRequested>(onAuthSignInRequested);
    on<AuthSignUpRequested>(onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(onAuthSignOutRequested);
    on<AuthSendEmailVerificationRequested>(
      onAuthSendEmailVerificationRequested,
    );
    on<AuthSendPasswordResetRequested>(onAuthSendPasswordResetRequested);
    on<AuthDeleteAccountRequested>(onAuthDeleteAccountRequested);
    on<AuthUpdateDisplayNameRequested>(onAuthUpdateDisplayNameRequested);
    on<AuthUpdateProfilePictureRequested>(onAuthUpdateProfilePictureRequested);
    on<AuthLoadProfileRequested>(onAuthLoadProfileRequested);
  }

  Future<void> onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userCredential = await authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Sign in failed. Please try again.'));
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
      final userCredential = await authService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (userCredential?.user != null) {
        // Send email verification after successful signup
        try {
          await authService.sendEmailVerification();
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
      final userCredential = await authService.signInWithGoogle();

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
      await authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> onAuthSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authService.sendEmailVerification();
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
      await authService.sendPasswordResetEmail(event.email);
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
      await authService.deleteAccount();
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

  Future<void> onAuthUpdateDisplayNameRequested(
    AuthUpdateDisplayNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authService.updateDisplayName(event.displayName);
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
      await authService.updateProfilePicture();
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
      if (authService.currentUser == null) {
        emit(const AuthError(message: 'User not authenticated'));
        return;
      }
    }

    emit(AuthLoading());

    try {
      final profile = await authService.getCurrentUserProfile();
      if (profile != null) {
        emit(AuthProfileLoaded(profile: profile));
      } else {
        emit(const AuthError(message: 'Failed to load user profile'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
