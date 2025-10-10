import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/features/blogs/presentation/widgets/bottom_nav_bar.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blogs_home.dart';
import 'package:blog_app/features/auth/presentation/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    context.read<AuthBloc>().add(AuthLoadProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileLoaded) {
          setState(() {
            userProfile = state.profile;
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
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
                      backgroundImage: userProfile?['photoURL'] != null
                          ? NetworkImage(userProfile!['photoURL'])
                          : null,
                      child: userProfile?['photoURL'] == null
                          ? Icon(Icons.person, color: Colors.white, size: 20)
                          : null,
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
      ),
    );
  }
}
