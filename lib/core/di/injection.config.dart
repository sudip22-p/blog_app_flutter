// // dart format width=80
// // GENERATED CODE - DO NOT MODIFY BY HAND

// // **************************************************************************
// // InjectableConfigGenerator
// // **************************************************************************

// // ignore_for_file: type=lint
// // coverage:ignore-file

// // ignore_for_file: no_leading_underscores_for_library_prefixes
// import 'package:blog_app/modules/onboarding/data/repository/onboarding_repository_impl.dart'
//     as _i156;
// import 'package:blog_app/modules/onboarding/domain/use_case/get_or_set_initial_show_onboarding_value_use_case.dart'
//     as _i792;
// import 'package:blog_app/modules/onboarding/domain/use_case/set_show_onboarding_value_use_case.dart'
//     as _i663;
// import 'package:blog_app/modules/onboarding/onboarding.dart' as _i646;
// import 'package:blog_app/modules/select_language/data/repository/select_language_repository_impl.dart'
//     as _i611;
// import 'package:blog_app/modules/select_language/domain/use_case/get_or_set_initial_selected_language_use_case.dart'
//     as _i73;
// import 'package:blog_app/modules/select_language/domain/use_case/get_or_set_initial_show_select_language_value_use_case.dart'
//     as _i1003;
// import 'package:blog_app/modules/select_language/domain/use_case/set_selected_language_use_case.dart'
//     as _i614;
// import 'package:blog_app/modules/select_language/domain/use_case/set_show_select_language_value_use_case.dart'
//     as _i572;
// import 'package:blog_app/modules/select_language/select_language.dart' as _i937;
// import 'package:get_it/get_it.dart' as _i174;
// import 'package:injectable/injectable.dart' as _i526;

// extension GetItInjectableX on _i174.GetIt {
//   // initializes the registration of main-scope dependencies inside of GetIt
//   _i174.GetIt init({
//     String? environment,
//     _i526.EnvironmentFilter? environmentFilter,
//   }) {
//     final gh = _i526.GetItHelper(this, environment, environmentFilter);
//     gh.factory<_i937.SelectLanguageRepository>(
//       () => _i611.SelectLanguageRepositoryImpl(),
//     );
//     gh.factory<_i646.OnboardingRepository>(
//       () => _i156.OnboardingRepositoryImpl(),
//     );
//     gh.factory<_i572.SetShowSelectedLanguageValueUseCase>(
//       () => _i572.SetShowSelectedLanguageValueUseCase(
//         gh<_i937.SelectLanguageRepository>(),
//       ),
//     );
//     gh.factory<_i1003.GetOrSetInitialShowSelectLanguageValueUseCase>(
//       () => _i1003.GetOrSetInitialShowSelectLanguageValueUseCase(
//         gh<_i937.SelectLanguageRepository>(),
//       ),
//     );
//     gh.factory<_i614.SetSelectedLanguageUseCase>(
//       () => _i614.SetSelectedLanguageUseCase(
//         gh<_i937.SelectLanguageRepository>(),
//       ),
//     );
//     gh.factory<_i73.GetOrSetInitialSelectedLanguageUseCase>(
//       () => _i73.GetOrSetInitialSelectedLanguageUseCase(
//         gh<_i937.SelectLanguageRepository>(),
//       ),
//     );
//     gh.factory<_i663.SetShowOnboardingValueUseCase>(
//       () =>
//           _i663.SetShowOnboardingValueUseCase(gh<_i646.OnboardingRepository>()),
//     );
//     gh.factory<_i792.GetOrSetInitialShowOnboardingValueUseCase>(
//       () => _i792.GetOrSetInitialShowOnboardingValueUseCase(
//         gh<_i646.OnboardingRepository>(),
//       ),
//     );
//     return this;
//   }
// }
