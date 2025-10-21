import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/bloc/engagement_bloc.dart';
import 'package:blog_app/modules/blogs/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocConfig extends StatelessWidget {
  final Widget child;
  const GlobalBlocConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => BlogBloc()),
        BlocProvider(create: (_) => EngagementBloc()),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(lazy: false, create: (_) => ThemeCubit()),
      ],
      child: child,
    );
  }
}
