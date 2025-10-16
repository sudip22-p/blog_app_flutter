import 'package:blog_app/modules/auth/presentation/screens/dashboard.dart';
import 'package:blog_app/modules/auth/presentation/screens/login_screen.dart';
import 'package:blog_app/modules/auth/presentation/screens/signup_screen.dart';
import 'package:blog_app/modules/auth/presentation/screens/user_profile_screen.dart';
import 'package:blog_app/modules/blogs/presentation/screens/add_blog.dart';
// import 'package:blog_app/modules/blogs/presentation/screens/blog_preview_screen.dart';
// import 'package:blog_app/modules/blogs/presentation/screens/update_blog.dart';
import 'package:blog_app/modules/splash/auth_wrapper.dart';
import 'package:blog_app/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/common/observers/navigation_observer.dart';
import 'package:blog_app/common/router/routes.dart';
import 'package:blog_app/common/widgets/error/error_screen.dart';

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
    // GoRoute(
    //   name: Routes.blogDetails.name,
    //   path: Routes.blogDetails.path,
    //   builder: (context, state) => const BlogPreviewScreen(),
    // ),
    //add blog screen
    GoRoute(
      name: Routes.addBlog.name,
      path: Routes.addBlog.path,
      builder: (context, state) => const AddBlog(),
    ),
    //edit blog screen
    // GoRoute(
    //   name: Routes.editBlog.name,
    //   path: Routes.editBlog.path,
    //   builder: (context, state) => const UpdateBlog(),
    // ),
  ],
  errorBuilder: (context, state) {
    return ErrorScreen(
      error: state.error.toString(),
      location: state.fullPath ?? state.matchedLocation,
    );
  },
);
