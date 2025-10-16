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
    );
    if (logoutConfirmation && mounted) {
      context.read<AuthBloc>().add(AuthSignOutRequested());
    }
  }

  bool isLoading = false;

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
              const SizedBox(height: 24),

              // Action Buttons
              if (!isEditing) ...[
                // Email Verification Button
                if (userProfile.emailVerified == false)
                  CustomButton.outlined(
                    onTap: isLoading ? null : widget.sendEmailVerification,
                    label: isLoading ? '' : 'Verify Email',
                    textColor: context.customTheme.primary,
                    border: Border.all(
                      color: context.customTheme.primary,
                      width: 1.5,
                    ),
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    gap: const SizedBox(width: 8),
                    iconPosition: IconAlignment.start,
                  ),
                if (userProfile.emailVerified == false)
                  const SizedBox(height: 12),

                // Password Reset Button
                CustomButton.outlined(
                  onTap: isLoading ? null : widget.sendPasswordReset,
                  label: isLoading ? '' : 'Reset Password',
                  textColor: context.customTheme.primary,
                  border: Border.all(
                    color: context.customTheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: AppBorderRadius.mediumBorderRadius,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  gap: const SizedBox(width: 8),
                  iconPosition: IconAlignment.start,
                ),

                const SizedBox(height: 12),

                // Logout Button
                CustomButton.outlined(
                  onTap: showLogoutDialog,
                  label: 'Logout',
                  textColor: context.customTheme.error,
                  border: Border.all(
                    color: context.customTheme.error,
                    width: 1.5,
                  ),
                  borderRadius: AppBorderRadius.mediumBorderRadius,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  icon: Icon(
                    Icons.logout_outlined,
                    color: context.customTheme.error,
                  ),
                  gap: const SizedBox(width: 8),
                  iconPosition: IconAlignment.start,
                ),

                const SizedBox(height: 40),

                // Danger Zone
                DangerZoneSection(),
              ] else ...[
                // Edit Mode Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton.outlined(
                        onTap: widget.cancelEdit,
                        label: 'Cancel',
                        textColor: context.customTheme.info,
                        border: Border.all(
                          color: context.customTheme.info,
                          width: 1.5,
                        ),
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        icon: Icon(
                          Icons.close_outlined,
                          color: context.customTheme.info,
                        ),
                        gap: const SizedBox(width: 8),
                        iconPosition: IconAlignment.start,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton.outlined(
                        onTap: widget.saveChanges,
                        label: 'Save',
                        textColor: context.customTheme.success,
                        border: Border.all(
                          color: context.customTheme.success,
                          width: 1.5,
                        ),
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        icon: Icon(
                          Icons.save_outlined,
                          color: context.customTheme.success,
                        ),
                        gap: const SizedBox(width: 8),
                        iconPosition: IconAlignment.start,
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
