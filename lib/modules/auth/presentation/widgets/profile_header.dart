import 'package:blog_app/core/core.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/auths.dart';
import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.userProfile,
    required this.isEditing,
  });

  final UserProfileEntity? userProfile;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.customTheme.surface,
            context.customTheme.surface.withAlpha(180),
            context.customTheme.surface,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: AppBorderRadius.largeRadius,
          bottomRight: AppBorderRadius.largeRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.xlg, top: AppSpacing.md),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.customTheme.primary,
                  ),
                  padding: EdgeInsetsGeometry.all(AppSpacing.xxs),
                  child: CustomImageAvatar(
                    size: 200,
                    imageUrl: userProfile?.photoURL ?? '',
                    fit: BoxFit.cover,
                    placeHolderImage: AssetRoutes.defaultAvatarImagePath,
                  ),
                ),

                if (isEditing)
                  Positioned(
                    bottom: 8,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(
                          AuthUpdateProfilePictureRequested(),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.customTheme.contentSurface,
                        ),
                        padding: EdgeInsetsGeometry.all(AppSpacing.sm),
                        child: Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: context.customTheme.surface,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            AppGaps.gapH16,

            Text(
              userProfile?.displayName ??
                  (userProfile?.email.split('@')[0] ?? 'N/A'),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            AppGaps.gapH8,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 20,
                  color: context.customTheme.contentPrimary,
                ),

                AppGaps.gapW8,

                Text(
                  userProfile?.email ?? 'N/A',
                  style: context.textTheme.bodyMedium,
                ),

                AppGaps.gapW8,

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: userProfile?.emailVerified == true
                        ? context.customTheme.success
                        : context.customTheme.error,
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                  ),
                  child: Text(
                    userProfile?.emailVerified == true
                        ? 'Verified'
                        : 'Not Verified',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.background,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            AppGaps.gapH8,
          ],
        ),
      ),
    );
  }
}
