import 'dart:async';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/di/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //AUTHENTICATION USECASES
  final SignInWithEmailAndPasswordUseCase signInUseCase =
      getIt<SignInWithEmailAndPasswordUseCase>();
  final CreateUserWithEmailAndPasswordUseCase signUpUseCase =
      getIt<CreateUserWithEmailAndPasswordUseCase>();
  final SignInWithGoogleUseCase signInWithGoogleUseCase =
      getIt<SignInWithGoogleUseCase>();
  final SignOutUseCase signOutUseCase = getIt<SignOutUseCase>();

  AuthBloc() : super(AuthInitial()) {
    //AUTHENTICATION EVENTS
    on<AuthSignInRequested>(onAuthSignInRequested);
    on<AuthSignUpRequested>(onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(onAuthSignOutRequested);
  }

  //AUTHENTICATION HANDLERS
  Future<void> onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
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
          await getIt<SendEmailVerificationUseCase>().execute(NoParams());
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
      await signOutUseCase.execute(NoParams());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
