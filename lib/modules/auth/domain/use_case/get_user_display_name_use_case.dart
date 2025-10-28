import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class GetUserDisplayNameUseCase extends UseCase<Future<String>, NoParams> {
  GetUserDisplayNameUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<String> execute(NoParams params) async {
    return await _authRepository.getUserDisplayName();
  }
}
