import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});
  void showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password', style: context.textTheme.titleMedium),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email to receive reset instructions.',
                style: context.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: context.textTheme.bodyMedium,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.checkEmailField(value),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: context.textTheme.bodyMedium,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.customTheme.error,
              ),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordResetSent) {
                Navigator.pop(context);
                CustomSnackbar.showToastMessage(
                  type: ToastType.success,
                  message: state.message,
                );
              } else if (state is AuthError) {
                CustomSnackbar.showToastMessage(
                  type: ToastType.error,
                  message: state.message,
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        if (dialogFormKey.currentState?.validate() == true) {
                          context.read<AuthBloc>().add(
                            AuthSendPasswordResetRequested(
                              email: emailController.text.trim(),
                            ),
                          );
                        }
                      },
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Send Reset Email',
                        style: context.textTheme.bodySmall,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
        child: CustomButton.text(
          label: 'Forgot Password?',
          onTap: () => showForgotPasswordDialog(context),
          textColor: context.customTheme.error,
        ),
      ),
    );
  }
}
