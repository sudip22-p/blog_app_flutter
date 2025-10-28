import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:blog_app/common/common.dart';

class GetCurrentUserProfileUseCase
    extends UseCase<Future<UserProfileEntity>, NoParams> {
  GetCurrentUserProfileUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserProfileEntity> execute(NoParams params) async {
    return await _authRepository.getCurrentUserProfile();
  }
}
