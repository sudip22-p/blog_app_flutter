import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
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
          border: Border.all(color: context.customTheme.primary, width: 1.5),
          borderRadius: AppBorderRadius.mediumBorderRadius,
          padding: const EdgeInsets.symmetric(vertical: 12),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.g_mobiledata,
                  size: 28,
                  color: context.customTheme.primary,
                ),
          gap: const SizedBox(width: 8),
          iconPosition: IconAlignment.start,
        );
      },
    );
  }
}
