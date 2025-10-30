import 'package:injectable/injectable.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/auth.dart';

@injectable
class GetUserDisplayNameUseCase extends UseCase<Future<String>, NoParams> {
  GetUserDisplayNameUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  @override
  Future<String> execute(NoParams params) async {
    return await _profileRepository.getUserDisplayName();
  }
}
