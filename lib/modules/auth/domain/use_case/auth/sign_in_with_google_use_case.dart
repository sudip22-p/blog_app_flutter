import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
class SignInWithGoogleUseCase
    extends UseCase<Future<UserCredential?>, NoParams> {
  SignInWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserCredential?> execute(NoParams params) async {
    return await _authRepository.signInWithGoogle();
  }
}
