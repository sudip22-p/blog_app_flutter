import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class CreateUserWithEmailAndPasswordUseCase
    extends
        UseCase<
          Future<UserCredential?>,
          CreateUserWithEmailAndPasswordUseCaseParams
        > {
  CreateUserWithEmailAndPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserCredential?> execute(
    CreateUserWithEmailAndPasswordUseCaseParams params,
  ) async {
    return await _authRepository.createUserWithEmailAndPassword(
      params.email,
      params.password,
      params.name,
    );
  }
}

class CreateUserWithEmailAndPasswordUseCaseParams extends Equatable {
  const CreateUserWithEmailAndPasswordUseCaseParams({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [email, password, name];
}
