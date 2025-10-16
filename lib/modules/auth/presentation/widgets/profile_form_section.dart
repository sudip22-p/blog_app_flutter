import 'package:blog_app/common/widgets/buttons/app_button.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormSection extends StatefulWidget {
  final UserProfile userProfile;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback sendEmailVerification;
  final VoidCallback sendPasswordReset;
  final VoidCallback cancelEdit;
  final VoidCallback saveChanges;

  const ProfileFormSection({
    super.key,
    required this.userProfile,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.formKey,
    required this.sendEmailVerification,
    required this.sendPasswordReset,
    required this.cancelEdit,
    required this.saveChanges,
  });

  @override
  State<ProfileFormSection> createState() => _ProfileFormSectionState();
}

class _ProfileFormSectionState extends State<ProfileFormSection> {
  void showLogoutDialog() async {
    bool logoutConfirmation = await DialogUtils.showConfirmationDialog(
      context,
      title: "Logout Confirmation",
      message: "Are you sure you want to logout?",
      confirmText: "LOGOUT",
      barrierColor: context.customTheme.primary.withAlpha(150),
    );
    if (logoutConfirmation && mounted) {
      context.read<AuthBloc>().add(AuthSignOutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = widget.userProfile;
    bool isEditing = widget.isEditing;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Information', style: context.textTheme.bodyLarge),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isEditing
                      ? context.customTheme.contentPrimary
                      : context.customTheme.contentPrimary.withAlpha(100),
                ),
                controller: widget.nameController,
                enabled: isEditing,
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    isEditing ? Validators.checkFieldEmpty(value) : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                  labelStyle: context.textTheme.bodyMedium?.copyWith(
                    color: isEditing
                        ? context.customTheme.contentPrimary
                        : context.customTheme.contentPrimary.withAlpha(100),
                  ),
                  prefixIcon: Icon(Icons.person_outlined),
                  filled: !isEditing,
                  fillColor: isEditing ? null : context.customTheme.surface,
                ),
              ),
              const SizedBox(height: 16),

              // Email Field (Read-only)
              TextFormField(
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.customTheme.contentPrimary.withAlpha(100),
                ),
                controller: widget.emailController,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: context.textTheme.bodyMedium?.copyWith(
                    color: context.customTheme.contentPrimary.withAlpha(100),
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                  suffixIcon: userProfile.emailVerified == true
                      ? Icon(
                          Icons.verified_outlined,
                          color: context.customTheme.secondary,
                        )
                      : Icon(
                          Icons.warning_outlined,
                          color: context.customTheme.info,
                        ),
                  filled: true,
                  fillColor: context.customTheme.surface,
                ),
              ),
              const SizedBox(height: 8),

              // Email Verification Status
              Row(
                children: [
                  Icon(
                    userProfile.emailVerified == true
                        ? Icons.check_circle_outline
                        : Icons.warning_outlined,
                    size: 16,
                    color: userProfile.emailVerified == true
                        ? context.customTheme.success
                        : context.customTheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userProfile.emailVerified == true
                        ? 'Email verified'
                        : 'Email not verified',
                    style: TextStyle(
                      color: userProfile.emailVerified == true
                          ? context.customTheme.success
                          : context.customTheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              if (!isEditing) ...[
                // Email Verification Button
                if (userProfile.emailVerified == false)
                  CustomButton(
                    label: 'Verify Email',
                    onTap: widget.sendEmailVerification,
                    bgColor: context.customTheme.primary,
                    textColor: context.customTheme.background,
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                if (userProfile.emailVerified == false)
                  const SizedBox(height: 12),

                // Password Reset Button
                CustomButton(
                  label: 'Reset Password',
                  onTap: widget.sendPasswordReset,
                  bgColor: context.customTheme.primary,
                  textColor: context.customTheme.background,
                  borderRadius: AppBorderRadius.mediumBorderRadius,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),

                const SizedBox(height: 12),

                // Logout Button
                CustomButton.icon(
                  icon: Icon(
                    Icons.logout,
                    color: context.customTheme.background,
                  ),
                  label: 'Logout',
                  onTap: showLogoutDialog,
                  bgColor: context.customTheme.info,
                  textColor: context.customTheme.background,
                  borderRadius: AppBorderRadius.mediumBorderRadius,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),

                const SizedBox(height: 40),

                // Danger Zone
                DangerZoneSection(),
              ] else ...[
                // Edit Mode Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton.icon(
                        icon: Icon(
                          Icons.close_outlined,
                          color: context.customTheme.background,
                        ),
                        label: 'Cancel',
                        onTap: widget.cancelEdit,
                        bgColor: context.customTheme.contentBackground,
                        textColor: context.customTheme.background,
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton.icon(
                        icon: Icon(
                          Icons.save_outlined,
                          color: context.customTheme.background,
                        ),
                        label: 'Save',
                        onTap: widget.saveChanges,
                        bgColor: context.customTheme.success,
                        textColor: context.customTheme.background,
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
