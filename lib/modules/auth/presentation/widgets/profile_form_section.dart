import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormSection extends StatefulWidget {
  final UserProfileEntity? userProfile;
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
    bool isEditing = widget.isEditing;
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountLoading) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: context.textTheme.bodyLarge,
                ),

                AppGaps.gapH16,

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
                    prefixIcon: Icon(
                      Icons.person_outlined,
                      color: isEditing
                          ? context.customTheme.contentPrimary
                          : context.customTheme.contentPrimary.withAlpha(100),
                    ),
                    filled: !isEditing,
                    fillColor: isEditing ? null : context.customTheme.surface,
                  ),
                ),

                AppGaps.gapH16,

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
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: isEditing
                          ? context.customTheme.contentPrimary
                          : context.customTheme.contentPrimary.withAlpha(100),
                    ),
                    suffixIcon: widget.userProfile?.emailVerified == true
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

                AppGaps.gapH40,

                if (!isEditing) ...[
                  if (widget.userProfile?.emailVerified == false)
                    CustomButton.outlined(
                      onTap: isLoading ? null : widget.sendEmailVerification,
                      label: isLoading ? '' : 'Verify Email',
                      textColor: context.customTheme.primary,
                      border: Border.all(
                        color: context.customTheme.primary,
                        width: AppSpacing.xxs,
                      ),
                      borderRadius: AppBorderRadius.mediumBorderRadius,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      icon: isLoading
                          ? SizedBox(
                              width: AppSpacing.lg,
                              height: AppSpacing.lg,
                              child: CircularProgressIndicator(
                                strokeWidth: AppSpacing.xxs,
                                color: context.customTheme.primary,
                              ),
                            )
                          : null,
                      gap: AppGaps.gapW8,
                      iconPosition: IconAlignment.start,
                    ),

                  if (widget.userProfile?.emailVerified == false)
                    AppGaps.gapH12,

                  CustomButton.outlined(
                    onTap: isLoading ? null : widget.sendPasswordReset,
                    label: isLoading ? '' : 'Reset Password',
                    textColor: context.customTheme.primary,
                    border: Border.all(
                      color: context.customTheme.primary,
                      width: AppSpacing.xxs,
                    ),
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    icon: isLoading
                        ? SizedBox(
                            width: AppSpacing.lg,
                            height: AppSpacing.lg,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSpacing.xxs,
                              color: context.customTheme.primary,
                            ),
                          )
                        : null,
                    gap: AppGaps.gapW8,
                    iconPosition: IconAlignment.start,
                  ),

                  AppGaps.gapH12,

                  CustomButton.outlined(
                    onTap: showLogoutDialog,
                    label: 'Logout',
                    textColor: context.customTheme.error,
                    border: Border.all(
                      color: context.customTheme.error,
                      width: AppSpacing.xxs,
                    ),
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    icon: Icon(
                      Icons.logout_outlined,
                      color: context.customTheme.error,
                    ),
                    gap: AppGaps.gapW8,
                    iconPosition: IconAlignment.start,
                  ),

                  AppGaps.gapH40,

                  DangerZoneSection(),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton.outlined(
                          onTap: widget.cancelEdit,
                          label: 'Cancel',
                          textColor: context.customTheme.info,
                          border: Border.all(
                            color: context.customTheme.info,
                            width: AppSpacing.xxs,
                          ),
                          borderRadius: AppBorderRadius.mediumBorderRadius,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          icon: Icon(
                            Icons.close_outlined,
                            color: context.customTheme.info,
                          ),
                          gap: AppGaps.gapW8,
                          iconPosition: IconAlignment.start,
                        ),
                      ),

                      AppGaps.gapW16,

                      Expanded(
                        child: CustomButton.outlined(
                          onTap: widget.saveChanges,
                          label: 'Save',
                          textColor: context.customTheme.success,
                          border: Border.all(
                            color: context.customTheme.success,
                            width: AppSpacing.xxs,
                          ),
                          borderRadius: AppBorderRadius.mediumBorderRadius,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          icon: Icon(
                            Icons.save_outlined,
                            color: context.customTheme.success,
                          ),
                          gap: AppGaps.gapW8,
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
      ),
    );
  }
}
