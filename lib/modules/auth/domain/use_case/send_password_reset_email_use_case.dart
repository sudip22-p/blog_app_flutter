import 'package:equatable/equatable.dart';
import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class SendPasswordResetEmailUseCase
    extends UseCase<Future<void>, SendPasswordResetEmailUseCaseParams> {
  SendPasswordResetEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(SendPasswordResetEmailUseCaseParams params) async {
    return await _authRepository.sendPasswordResetEmail(params.email);
  }
}

class SendPasswordResetEmailUseCaseParams extends Equatable {
  const SendPasswordResetEmailUseCaseParams({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
