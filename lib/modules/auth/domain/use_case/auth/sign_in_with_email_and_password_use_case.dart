import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
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
