import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class SignInWithEmailAndPasswordUseCase
    extends
        UseCase<
          Future<UserCredential?>,
          SignInWithEmailAndPasswordUseCaseParams
        > {
  SignInWithEmailAndPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserCredential?> execute(
    SignInWithEmailAndPasswordUseCaseParams params,
  ) async {
    return await _authRepository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class SignInWithEmailAndPasswordUseCaseParams extends Equatable {
  const SignInWithEmailAndPasswordUseCaseParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
