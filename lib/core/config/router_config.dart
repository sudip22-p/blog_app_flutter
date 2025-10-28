import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/modules/dashboard/dashboard.dart';
import 'package:blog_app/modules/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/common/common.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  observers: [AppNavigatorObserver()],
  redirect: (context, state) {
    return null;
  },
  initialLocation: "/",
  routes: [
    //   //splash screen
    GoRoute(
      name: Routes.splash.name,
      path: Routes.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    //auth-wrapper for login state persistent
    GoRoute(
      name: Routes.authWrapper.name,
      path: Routes.authWrapper.path,
      builder: (context, state) => const AuthWrapper(),
    ),
    //login screen
    GoRoute(
      name: Routes.login.name,
      path: Routes.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    //signup screen
    GoRoute(
      name: Routes.signup.name,
      path: Routes.signup.path,
      builder: (context, state) => const SignUpScreen(),
    ),
    //dashboard
    GoRoute(
      name: Routes.dashboard.name,
      path: Routes.dashboard.path,
      builder: (context, state) => const Dashboard(),
    ),
    //user profile screen
    GoRoute(
      name: Routes.userProfile.name,
      path: Routes.userProfile.path,
      builder: (context, state) => const UserProfileScreen(),
    ),
    //blog details screen
    GoRoute(
      name: Routes.blogDetails.name,
      path: Routes.blogDetails.path,
      builder: (context, state) {
        final blog = state.extra as Blog;
        return BlogPreviewScreen(blog: blog);
      },
    ),
    //add blog screen
    GoRoute(
      name: Routes.addBlog.name,
      path: Routes.addBlog.path,
      builder: (context, state) => const AddBlog(),
    ),
    //edit blog screen
    GoRoute(
      name: Routes.editBlog.name,
      path: Routes.editBlog.path,
      builder: (context, state) {
        final blog = state.extra as Blog;
        return UpdateBlog(blog: blog);
      },
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorScreen(
      error: state.error.toString(),
      location: state.fullPath ?? state.matchedLocation,
    );
  },
);
