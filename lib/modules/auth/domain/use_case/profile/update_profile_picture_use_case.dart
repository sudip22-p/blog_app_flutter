import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
class UpdateProfilePictureUseCase extends UseCase<Future<void>, NoParams> {
  UpdateProfilePictureUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  @override
  Future<void> execute(NoParams params) async {
    return await _profileRepository.updateProfilePicture();
  }
}
