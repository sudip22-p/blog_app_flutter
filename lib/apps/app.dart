import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/theme/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBlocConfig(child: BlogAppView());
  }
}

class BlogAppView extends StatelessWidget {
  const BlogAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// setting device screen size for responsiveness
        Device.setScreenSize(context, constraints);
        return BlocBuilder<ThemeCubit, ThemeModeState>(
          builder: (context, themeModeState) {
            return MaterialApp.router(
              /// app title
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,

              /// theme config
              theme: ThemeConfigs.lightTheme(),
              darkTheme: ThemeConfigs.darkTheme(),
              themeMode: themeModeState.themeMode,

              /// routing config
              routerConfig: router,

              ///builder
              builder: (_, child) => child!,
            );
          },
        );
      },
    );
  }
}
