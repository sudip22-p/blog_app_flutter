import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/auth.dart';

@injectable
class DeleteAccountUseCase extends UseCase<Future<void>, NoParams> {
  DeleteAccountUseCase(this._accountRepository);

  final AccountRepository _accountRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _accountRepository.deleteAccount();
  }
}
