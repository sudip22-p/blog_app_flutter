import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/modules/blogs/blog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? userProfile;

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
            userProfile = UserProfile.fromJson(state.profile);
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.customTheme.background,
            appBar: AppBar(
              backgroundColor: context.customTheme.surface,
              title: Text('Blog App', style: context.textTheme.titleMedium),
              actions: [
                const ThemeSwitcher(),
                // Profile Avatar Button
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.userProfile.name);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, left: 8),
                    child: CustomImageAvatar(
                      size: 40,
                      imageUrl: userProfile?.photoURL ?? '',
                      fit: BoxFit.cover,
                      placeHolderImage: AssetRoutes.defaultAvatarImagePath,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              centerTitle: false,
            ),
            body: const BlogsHome(),
            // bottomNavigationBar: const BottomNavBar(selection: 0),
          );
        },
      ),
    );
  }
}
