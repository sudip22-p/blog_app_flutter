import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/danger_zone_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormSection extends StatefulWidget {
  final ColorScheme colorScheme;
  final Map<String, dynamic>? userProfile;
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
    required this.colorScheme,
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
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthSignOutRequested());
              Navigator.pop(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic userProfile = widget.userProfile;
    bool isEditing = widget.isEditing;
    ColorScheme colorScheme = widget.colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: widget.nameController,
                enabled: isEditing,
                validator: isEditing ? validateName : null,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  filled: !isEditing,
                  fillColor: isEditing
                      ? null
                      : colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 16),

              // Email Field (Read-only)
              TextFormField(
                controller: widget.emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  suffixIcon: userProfile?['emailVerified'] == true
                      ? Icon(Icons.verified, color: colorScheme.secondary)
                      : Icon(Icons.warning, color: colorScheme.error),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 8),

              // Email Verification Status
              Row(
                children: [
                  Icon(
                    userProfile?['emailVerified'] == true
                        ? Icons.check_circle
                        : Icons.warning,
                    size: 16,
                    color: userProfile?['emailVerified'] == true
                        ? colorScheme.secondary
                        : colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userProfile?['emailVerified'] == true
                        ? 'Email verified'
                        : 'Email not verified',
                    style: TextStyle(
                      color: userProfile?['emailVerified'] == true
                          ? colorScheme.secondary
                          : colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              if (!isEditing) ...[
                // Email Verification Button
                if (userProfile?['emailVerified'] == false)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.sendEmailVerification,
                      icon: const Icon(Icons.email),
                      label: const Text('Verify Email'),
                    ),
                  ),

                if (userProfile?['emailVerified'] == false)
                  const SizedBox(height: 12),

                // Password Reset Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.sendPasswordReset,
                    icon: const Icon(Icons.lock_reset),
                    label: const Text('Reset Password'),
                  ),
                ),

                const SizedBox(height: 12),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: showLogoutDialog,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),

                const SizedBox(height: 40),

                // Danger Zone
                DangerZoneSection(colorScheme: colorScheme),
              ] else ...[
                // Edit Mode Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.cancelEdit,
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.saveChanges,
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
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
