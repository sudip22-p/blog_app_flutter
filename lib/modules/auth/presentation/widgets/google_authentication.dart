import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAuthentication extends StatelessWidget {
  const GoogleAuthentication({super.key});
  void signInWithGoogle(BuildContext context) {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return CustomButton.outlined(
          onTap: isLoading
              ? null
              : () {
                  signInWithGoogle(context);
                },
          label: isLoading ? '' : 'Continue with Google',
          textColor: context.customTheme.primary,
          border: Border.all(
            color: context.customTheme.primary,
            width: AppSpacing.xxs,
          ),
          borderRadius: AppBorderRadius.mediumBorderRadius,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          icon: isLoading
              ? SizedBox(
                  width: AppSpacing.lg,
                  height: AppSpacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSpacing.xxs,
                    color: context.customTheme.primary,
                  ),
                )
              : Icon(
                  Icons.g_mobiledata,
                  size: 28,
                  color: context.customTheme.primary,
                ),
          gap: AppGaps.gapW8,
          iconPosition: IconAlignment.start,
        );
      },
    );
  }
}
