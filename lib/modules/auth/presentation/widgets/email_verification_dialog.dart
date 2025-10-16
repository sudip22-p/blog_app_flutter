import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerificationDialog extends StatelessWidget {
  const EmailVerificationDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Account Created!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: context.customTheme.success,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          const Text(
            'Would you like to send a verification email to your account?',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back to login
          },
          child: const Text('Skip'),
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthEmailVerificationSent) {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to login
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                      context.read<AuthBloc>().add(
                        AuthSendEmailVerificationRequested(),
                      );
                    },
              child: state is AuthLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Verification'),
            );
          },
        ),
      ],
    );
  }
}
