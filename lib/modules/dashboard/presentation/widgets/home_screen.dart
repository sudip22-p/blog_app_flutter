import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/modules/auth/auths.dart';
import 'package:blog_app/modules/blogs/blogs.dart';

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
            appBar: CustomAppBarWidget(
              title: Text(
                "Blog App",
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.customTheme.primary,
                ),
              ),
              // centerTitle: true,
              backgroundColor: context.customTheme.surface,
              // showBackButton: true,
              actions: [
                const ThemeSwitcher(),

                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.userProfile.name);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: AppSpacing.lg,
                      left: AppSpacing.sm,
                    ),
                    child: CustomImageAvatar(
                      size: AppSpacing.xxlg,
                      imageUrl: userProfile?.photoURL ?? '',
                      fit: BoxFit.cover,
                      placeHolderImage: AssetRoutes.defaultAvatarImagePath,
                    ),
                  ),
                ),
              ],
            ),

            body: const TrendingBlogs(),
          );
        },
      ),
    );
  }
}
