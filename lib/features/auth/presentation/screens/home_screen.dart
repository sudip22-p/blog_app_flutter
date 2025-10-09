import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/features/blogs/presentation/widgets/bottom_nav_bar.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blogs_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Blog App',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            actions: [
              const ThemeSwitcher(),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'profile') {
                    showDialog(
                      context: context,
                      builder: (dialogContext) =>
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final user = (state is AuthAuthenticated)
                                  ? state.user
                                  : null;

                              return ProfileDialog(
                                user: user,
                                dialogContext: dialogContext,
                              );
                            },
                          ),
                    );
                  } else if (value == 'logout') {
                    showDialog(
                      context: context,
                      builder: (dialogContext) =>
                          BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthError) {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            },
                            child: LogOutDialog(dialogContext: dialogContext),
                          ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Sign Out'),
                      ],
                    ),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: false,
          ),
          body: const BlogsHome(),
          bottomNavigationBar: const BottomNavBar(selection: 0),
        );
      },
    );
  }
}

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key, required this.dialogContext});
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
            Navigator.pop(dialogContext);
          },
          child: Text(
            'Sign Out',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    super.key,
    required this.user,
    required this.dialogContext,
  });

  final User? user;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAccountDeleted) {
          Navigator.pop(dialogContext);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(user?.displayName ?? 'No name')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text(user?.email ?? 'No email')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  user?.emailVerified == true ? Icons.verified : Icons.warning,
                  color: user?.emailVerified == true
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  user?.emailVerified == true
                      ? 'Email Verified'
                      : 'Email Not Verified',
                ),
              ],
            ),
            if (user?.emailVerified == false) ...[
              const SizedBox(height: 12),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthEmailVerificationSent) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: TextButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthSendEmailVerificationRequested(),
                    );
                  },
                  icon: const Icon(Icons.email),
                  label: const Text('Resend Verification'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Divider(),
            // Delete Account (Danger Zone)
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DeleteAccountDialog(),
                ),
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'This action cannot be undone. All your data will be permanently deleted.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                      Navigator.pop(context); // Close delete dialog
                      context.read<AuthBloc>().add(
                        AuthDeleteAccountRequested(),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: state is AuthLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Delete Forever'),
            );
          },
        ),
      ],
    );
  }
}
