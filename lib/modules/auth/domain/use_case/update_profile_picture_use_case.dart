import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class UpdateProfilePictureUseCase extends UseCase<Future<void>, NoParams> {
  UpdateProfilePictureUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _authRepository.updateProfilePicture();
  }
}
