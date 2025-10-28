import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocConfig extends StatelessWidget {
  final Widget child;
  const GlobalBlocConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AccountBloc()),
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(create: (_) => ProfileBloc()),
            BlocProvider(create: (_) => BlogBloc()),
            BlocProvider(create: (_) => EngagementBloc()),
            BlocProvider(create: (_) => FavoritesBloc()),
            BlocProvider(lazy: false, create: (_) => ThemeCubit()),
          ],
          child: child,
        );
      },
    );
  }
}
