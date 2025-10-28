import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
class SendPasswordResetEmailUseCase
    extends UseCase<Future<void>, SendPasswordResetEmailUseCaseParams> {
  SendPasswordResetEmailUseCase(this._accountRepository);

  final AccountRepository _accountRepository;

  @override
  Future<void> execute(SendPasswordResetEmailUseCaseParams params) async {
    return await _accountRepository.sendPasswordResetEmail(params.email);
  }
}

class SendPasswordResetEmailUseCaseParams extends Equatable {
  const SendPasswordResetEmailUseCaseParams({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
