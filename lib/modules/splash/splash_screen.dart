import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) {
        context.goNamed(Routes.authWrapper.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.customTheme.primary,
        child: Center(
          child: Text("Blog App", style: context.textTheme.displaySmall),
        ),
      ),
    );
  }
}
