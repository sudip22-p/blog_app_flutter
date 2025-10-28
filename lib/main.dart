import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'apps/apps.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //set hydrated bloc storage
  await _setUpHydratedStorage();

  //firebase releated setup
  await firebaseSetup();

  // initiating bloc observer
  Bloc.observer = AppBlocObserver();

  //locking device orientation to potrait view
  setDeviceOrientationToPortrait();

  //awaiting di
  configureDependencyInjection();

  runApp(const BlogApp());
}

void setDeviceOrientationToPortrait() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> firebaseSetup() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _setUpHydratedStorage() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
}
