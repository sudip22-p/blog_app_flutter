import 'package:blog_app/modules/dashboard/presentation/views/dashboard.dart';
import 'package:blog_app/modules/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // stream: FirebaseAuth.instance.idTokenChanges(),
      // stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        // Show loading while waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is authenticated, show home screen
        if (snapshot.hasData && snapshot.data != null) {
          return const Dashboard();
        }

        // If user is not authenticated, show login screen
        return const LoginScreen();
      },
    );
  }
}
