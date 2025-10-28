import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class SendEmailVerificationUseCase extends UseCase<Future<void>, NoParams> {
  SendEmailVerificationUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _authRepository.sendEmailVerification();
  }
}
