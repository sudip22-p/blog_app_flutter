import './injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

///
///Dependency Injection Cannot be done with classes with constructors
///
final GetIt getIt = GetIt.instance;

@injectableInit
void configureDependencyInjection() {
  getIt.init();
}
