import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:blog_app/common/common.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';

@injectable
class GetCurrentUserProfileUseCase
    extends UseCase<Future<UserProfileEntity>, NoParams> {
  GetCurrentUserProfileUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  @override
  Future<UserProfileEntity> execute(NoParams params) async {
    return await _profileRepository.getCurrentUserProfile();
  }
}
