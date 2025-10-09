import 'dart:async';
import 'package:blog_app/features/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(AuthInitial()) {
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthSendEmailVerificationRequested>(
      _onAuthSendEmailVerificationRequested,
    );
    on<AuthSendPasswordResetRequested>(_onAuthSendPasswordResetRequested);
    on<AuthDeleteAccountRequested>(_onAuthDeleteAccountRequested);
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
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

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (userCredential?.user != null) {
        // Send email verification after successful signup
        try {
          await _authService.sendEmailVerification();
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

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Google sign-in was cancelled.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.sendEmailVerification();
      emit(
        const AuthEmailVerificationSent(
          message: 'Verification email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSendPasswordResetRequested(
    AuthSendPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(
        const AuthPasswordResetSent(
          message: 'Password reset email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authService.deleteAccount();
      emit(const AuthAccountDeleted(message: 'Account deleted successfully.'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
