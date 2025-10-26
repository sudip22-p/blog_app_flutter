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
    final theme = context.customTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: AppSpacing.xxxlg,
                color: theme.primary,
              ),

              AppGaps.gapH12,

              Text("Blog App", style: context.textTheme.headlineMedium),

              AppGaps.gapH4,

              Text(
                "share your thoughts freely",
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
