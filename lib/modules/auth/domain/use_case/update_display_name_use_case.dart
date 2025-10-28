import 'package:equatable/equatable.dart';
import '../repository/repository.dart';
import 'package:blog_app/common/common.dart';

class UpdateDisplayNameUseCase
    extends UseCase<Future<void>, UpdateDisplayNameUseCaseParams> {
  UpdateDisplayNameUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(UpdateDisplayNameUseCaseParams params) async {
    return await _authRepository.updateDisplayName(params.displayName);
  }
}

class UpdateDisplayNameUseCaseParams extends Equatable {
  const UpdateDisplayNameUseCaseParams({required this.displayName});
  final String displayName;

  @override
  List<Object?> get props => [displayName];
}
