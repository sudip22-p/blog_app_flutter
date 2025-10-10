import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/features/blogs/presentation/widgets/bottom_nav_bar.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blogs_home.dart';
import 'package:blog_app/features/auth/presentation/screens/user_profile_screen.dart';
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
              // Profile Avatar Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16, left: 8),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
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
