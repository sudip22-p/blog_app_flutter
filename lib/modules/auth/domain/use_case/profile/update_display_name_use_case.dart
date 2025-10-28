import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/common/common.dart';

@injectable
class UpdateDisplayNameUseCase
    extends UseCase<Future<void>, UpdateDisplayNameUseCaseParams> {
  UpdateDisplayNameUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  @override
  Future<void> execute(UpdateDisplayNameUseCaseParams params) async {
    return await _profileRepository.updateDisplayName(params.displayName);
  }
}

class UpdateDisplayNameUseCaseParams extends Equatable {
  const UpdateDisplayNameUseCaseParams({required this.displayName});
  final String displayName;

  @override
  List<Object?> get props => [displayName];
}
