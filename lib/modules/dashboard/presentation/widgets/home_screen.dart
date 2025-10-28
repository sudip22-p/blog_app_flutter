import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/modules/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/modules/blogs/blogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfileEntity? userProfile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.surface,
      appBar: CustomAppBarWidget(
        title: Text(
          "Blog App",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        backgroundColor: context.customTheme.background,
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
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final userProfile = state is ProfileLoaded
                      ? state.profile
                      : null;
                  return CustomImageAvatar(
                    size: AppSpacing.xxlg,
                    imageUrl: userProfile?.photoURL ?? '',
                    fit: BoxFit.cover,
                    placeHolderImage: AssetRoutes.defaultAvatarImagePath,
                  );
                },
              ),
            ),
          ),
        ],
      ),

      body: const LatestBlogs(),
    );
  }
}
