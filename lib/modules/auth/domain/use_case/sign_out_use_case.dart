import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class SignOutUseCase extends UseCase<Future<void>, NoParams> {
  SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _authRepository.signOut();
  }
}
