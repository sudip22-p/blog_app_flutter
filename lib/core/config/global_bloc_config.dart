import 'package:blog_app/modules/auth/auths.dart';
import 'package:blog_app/modules/auth/data/data.dart';
import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocConfig extends StatelessWidget {
  final Widget child;
  const GlobalBlocConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(create: (_) => BlogBloc()),
          BlocProvider(create: (_) => EngagementBloc()),
          BlocProvider(create: (_) => FavoritesBloc()),
          BlocProvider(lazy: false, create: (_) => ThemeCubit()),
        ],
        child: child,
      ),
    );
  }
}
