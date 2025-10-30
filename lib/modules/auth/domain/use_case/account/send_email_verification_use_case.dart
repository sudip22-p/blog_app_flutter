import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
class SendEmailVerificationUseCase extends UseCase<Future<void>, NoParams> {
  SendEmailVerificationUseCase(this._accountRepository);

  final AccountRepository _accountRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _accountRepository.sendEmailVerification();
  }
}
