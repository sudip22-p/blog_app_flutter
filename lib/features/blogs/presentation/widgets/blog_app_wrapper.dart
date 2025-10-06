import 'package:blog_app/features/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:blog_app/features/blogs/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:blog_app/features/blogs/presentation/bloc/favorites/favorites_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogAppWrapper extends StatelessWidget {
  final Widget child;

  const BlogAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BlogBloc()),
        BlocProvider(create: (context) => EngagementBloc()),
        BlocProvider(
          create: (context) => FavoritesBloc()
            ..add(
              LoadUserFavorites(FirebaseAuth.instance.currentUser?.uid ?? ''),
            ),
        ),
      ],
      child: child,
    );
  }
}
