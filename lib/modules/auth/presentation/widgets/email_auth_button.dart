import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAuthButton extends StatelessWidget {
  const EmailAuthButton({
    super.key,
    required this.isLogin,
    required this.authentication,
  });
  final bool isLogin;
  final VoidCallback authentication;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return CustomButton(
          label: isLoading
              ? ''
              : isLogin
              ? 'Sign In'
              : 'Create Account',
          onTap: isLoading ? null : authentication,
          bgColor: context.customTheme.primary,
          textColor: context.customTheme.background,
          borderRadius: AppBorderRadius.mediumBorderRadius,
          padding: const EdgeInsets.symmetric(vertical: 12),
          icon: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.customTheme.contentPrimary,
                  ),
                )
              : null,
        );
      },
    );
  }
}
