import 'package:blog_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginButtonPresssed>(_onLoginButtonPressed);
    on<AuthSignUpButtonPresssed>(_onSignUpButtonPresssed);
    on<AuthLogoutButtonPressed>(_onLogoutButtonPressed);
  }
  // @override
  // void onChange(Change<AuthState> change) {
  //   super.onChange(change);
  //   print('auth bloc change - $change');
  // }

  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   super.onTransition(transition);
  //   print("sud transition- $transition");
  // }

  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   super.onError(error, stackTrace);
  //   print("sud error- $error");
  //   print("sud stack trace- $stackTrace");
  // }

  void _onLoginButtonPressed(
    AuthLoginButtonPresssed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      //get the email password and check the validity
      final email = event.email;
      final password = event.password;
      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(email)) {
        return emit(AuthFailure(errorMessage: "Invalid email address! "));
      }
      if (password.length < 6) {
        return emit(
          AuthFailure(
            errorMessage: "Password must be at least 6 character long.",
          ),
        );
      }
      final firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
      await firebaseAuthMethods.signInWithEmail(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthSuccess(uid: user.uid));
      } else {
        emit(AuthFailure(errorMessage: "Failed to sign in"));
      }
    } catch (e) {
      return emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  void _onSignUpButtonPresssed(
    AuthSignUpButtonPresssed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final email = event.email;
      final password = event.password;
      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(email)) {
        return emit(AuthFailure(errorMessage: "Invalid email address! "));
      }
      if (password.length < 6) {
        return emit(
          AuthFailure(
            errorMessage: "Password must be at least 6 character long.",
          ),
        );
      }
      final firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
      await firebaseAuthMethods.signUpWithEmail(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthSuccess(uid: user.uid));
      } else {
        emit(AuthFailure(errorMessage: "Failed to create user account"));
      }
    } catch (e) {
      return emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  void _onLogoutButtonPressed(
    AuthLogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
      await firebaseAuthMethods.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
