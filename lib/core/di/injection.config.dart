// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:blog_app/modules/auth/auth.dart' as _i175;
import 'package:blog_app/modules/auth/data/repository/account_repository_impl.dart'
    as _i638;
import 'package:blog_app/modules/auth/data/repository/auth_repository_impl.dart'
    as _i90;
import 'package:blog_app/modules/auth/data/repository/profile_repository_impl.dart'
    as _i473;
import 'package:blog_app/modules/auth/domain/domain.dart' as _i550;
import 'package:blog_app/modules/auth/domain/use_case/account/delete_account_use_case.dart'
    as _i296;
import 'package:blog_app/modules/auth/domain/use_case/account/send_email_verification_use_case.dart'
    as _i274;
import 'package:blog_app/modules/auth/domain/use_case/account/send_password_reset_email_use_case.dart'
    as _i183;
import 'package:blog_app/modules/auth/domain/use_case/auth/create_user_with_email_and_password_use_case.dart'
    as _i488;
import 'package:blog_app/modules/auth/domain/use_case/auth/sign_in_with_email_and_password_use_case.dart'
    as _i800;
import 'package:blog_app/modules/auth/domain/use_case/auth/sign_in_with_google_use_case.dart'
    as _i434;
import 'package:blog_app/modules/auth/domain/use_case/auth/sign_out_use_case.dart'
    as _i359;
import 'package:blog_app/modules/auth/domain/use_case/profile/get_current_user_profile_use_case.dart'
    as _i861;
import 'package:blog_app/modules/auth/domain/use_case/profile/get_user_display_name_use_case.dart'
    as _i790;
import 'package:blog_app/modules/auth/domain/use_case/profile/update_display_name_use_case.dart'
    as _i1031;
import 'package:blog_app/modules/auth/domain/use_case/profile/update_profile_picture_use_case.dart'
    as _i469;
import 'package:blog_app/modules/auth/presentation/bloc/account/account_bloc.dart'
    as _i517;
import 'package:blog_app/modules/auth/presentation/bloc/auth/auth_bloc.dart'
    as _i368;
import 'package:blog_app/modules/auth/presentation/bloc/profile/profile_bloc.dart'
    as _i221;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i517.AccountBloc>(() => _i517.AccountBloc());
    gh.factory<_i368.AuthBloc>(() => _i368.AuthBloc());
    gh.factory<_i221.ProfileBloc>(() => _i221.ProfileBloc());
    gh.factory<_i175.ProfileRepository>(() => _i473.ProfileRepositoryImpl());
    gh.factory<_i175.AccountRepository>(() => _i638.AccountRepositoryImpl());
    gh.factory<_i175.AuthRepository>(() => _i90.AuthRepositoryImpl());
    gh.factory<_i861.GetCurrentUserProfileUseCase>(
      () => _i861.GetCurrentUserProfileUseCase(gh<_i550.ProfileRepository>()),
    );
    gh.factory<_i790.GetUserDisplayNameUseCase>(
      () => _i790.GetUserDisplayNameUseCase(gh<_i175.ProfileRepository>()),
    );
    gh.factory<_i1031.UpdateDisplayNameUseCase>(
      () => _i1031.UpdateDisplayNameUseCase(gh<_i175.ProfileRepository>()),
    );
    gh.factory<_i469.UpdateProfilePictureUseCase>(
      () => _i469.UpdateProfilePictureUseCase(gh<_i175.ProfileRepository>()),
    );
    gh.factory<_i296.DeleteAccountUseCase>(
      () => _i296.DeleteAccountUseCase(gh<_i175.AccountRepository>()),
    );
    gh.factory<_i274.SendEmailVerificationUseCase>(
      () => _i274.SendEmailVerificationUseCase(gh<_i175.AccountRepository>()),
    );
    gh.factory<_i183.SendPasswordResetEmailUseCase>(
      () => _i183.SendPasswordResetEmailUseCase(gh<_i175.AccountRepository>()),
    );
    gh.factory<_i488.CreateUserWithEmailAndPasswordUseCase>(
      () => _i488.CreateUserWithEmailAndPasswordUseCase(
        gh<_i175.AuthRepository>(),
      ),
    );
    gh.factory<_i800.SignInWithEmailAndPasswordUseCase>(
      () => _i800.SignInWithEmailAndPasswordUseCase(gh<_i175.AuthRepository>()),
    );
    gh.factory<_i434.SignInWithGoogleUseCase>(
      () => _i434.SignInWithGoogleUseCase(gh<_i175.AuthRepository>()),
    );
    gh.factory<_i359.SignOutUseCase>(
      () => _i359.SignOutUseCase(gh<_i175.AuthRepository>()),
    );
    return this;
  }
}
