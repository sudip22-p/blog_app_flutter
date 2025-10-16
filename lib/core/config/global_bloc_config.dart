import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/favorites/favorites_bloc.dart';
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
        
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => BlogBloc()),
        BlocProvider(create: (context) => EngagementBloc()),
        BlocProvider(create: (context) => FavoritesBloc()),
        BlocProvider(lazy: false, create: (_) => ThemeCubit()),
      ],
      child: child,
    );
  }
}
