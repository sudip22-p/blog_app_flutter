
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.colorScheme,
    required this.userProfile,
    required this.isEditing,
  });

  final ColorScheme colorScheme;
  final Map<String, dynamic>? userProfile;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primary.withAlpha(204)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 40,
          top: 20,
        ),
        child: Column(
          children: [
            // Enhanced Avatar Section
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage: userProfile?['photoURL'] != null
                        ? NetworkImage(userProfile!['photoURL'])
                        : null,
                    child: userProfile?['photoURL'] == null
                        ? Text(
                            userProfile?['displayName']?.isNotEmpty == true
                                ? userProfile!['displayName'][0].toUpperCase()
                                : (userProfile?['email']?.isNotEmpty == true
                                      ? userProfile!['email'][0].toUpperCase()
                                      : 'U'),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(
                          AuthUpdateProfilePictureRequested(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withAlpha(25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // User Name Display
            Text(
              userProfile?['displayName']?.isNotEmpty == true
                  ? userProfile!['displayName']
                  : (userProfile?['email']?.split('@')[0] ?? 'User'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Email with verification status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 16,
                  color: colorScheme.onPrimary.withAlpha(230),
                ),
                const SizedBox(width: 8),
                Text(
                  userProfile?['email'] ?? 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary.withAlpha(230),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: userProfile?['emailVerified'] == true
                        ? colorScheme.secondary
                        : colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    userProfile?['emailVerified'] == true
                        ? 'Verified'
                        : 'Unverified',
                    style: TextStyle(
                      fontSize: 10,
                      color: userProfile?['emailVerified'] == true
                          ? colorScheme.onSecondary
                          : colorScheme.onTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
