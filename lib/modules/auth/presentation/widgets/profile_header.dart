import 'package:blog_app/core/core.dart';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.userProfile,
    required this.isEditing,
  });

  final UserProfile userProfile;
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.customTheme.surface,
                  ),
                  padding: EdgeInsetsGeometry.all(3),
                  child: CustomImageAvatar(
                    size: 200,
                    imageUrl: userProfile.photoURL ?? '',
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
                          color: context.customTheme.contentPrimary,
                        ),
                        padding: EdgeInsetsGeometry.all(7),
                        child: Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: context.customTheme.background,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // User Name Display
            Text(
              userProfile.displayName ??
                  (userProfile.email?.split('@')[0] ?? 'N/A'),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Email with verification status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 20,
                  color: context.customTheme.contentPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  userProfile.email ?? 'N/A',
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: userProfile.emailVerified == true
                        ? context.customTheme.success
                        : context.customTheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    userProfile.emailVerified == true
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
