import 'package:firebase_auth/firebase_auth.dart';

import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class SignInWithGoogleUseCase
    extends UseCase<Future<UserCredential?>, NoParams> {
  SignInWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserCredential?> execute(NoParams params) async {
    return await _authRepository.signInWithGoogle();
  }
}
