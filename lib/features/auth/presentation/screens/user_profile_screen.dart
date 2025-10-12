import 'package:blog_app/features/auth/presentation/widgets/profile_form_section.dart';
import 'package:blog_app/features/auth/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    // Always load profile when screen initializes
    loadUserProfile();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> loadUserProfile() async {
    context.read<AuthBloc>().add(AuthLoadProfileRequested());
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();
      context.read<AuthBloc>().add(
        AuthUpdateDisplayNameRequested(displayName: newName),
      );
    }
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      _nameController.text = userProfile?['displayName'] ?? '';
    });
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Reset form if canceling edit
        _nameController.text = userProfile?['displayName'] ?? '';
      }
    });
  }

  void sendEmailVerification() {
    if (userProfile?['emailVerified'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is already verified!')),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthSendEmailVerificationRequested());
  }

  void sendPasswordReset() {
    final email = userProfile?['email'];
    if (email != null) {
      context.read<AuthBloc>().add(
        AuthSendPasswordResetRequested(email: email),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not found. Please try again.')),
      );
    }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          ),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: toggleEdit,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.edit, color: colorScheme.primary),
              ),
            ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileLoaded) {
            setState(() {
              userProfile = state.profile;
              _nameController.text = state.profile['displayName'] ?? '';
              _emailController.text = state.profile['email'] ?? '';
            });
          } else if (state is AuthProfileUpdated) {
            setState(() {
              isEditing = false;
            });
            loadUserProfile(); // Reload the profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
          } else if (state is AuthEmailVerificationSent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthPasswordResetSent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAccountDeleted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthUnauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is AuthInitial) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Show loading indicator if loading or profile is null
            if (state is AuthLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (userProfile == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Section
                  ProfileHeader(
                    colorScheme: colorScheme,
                    userProfile: userProfile,
                    isEditing: isEditing,
                  ),

                  const SizedBox(height: 24),

                  // Profile Form Section
                  ProfileFormSection(
                    colorScheme: colorScheme,
                    userProfile: userProfile,
                    isEditing: isEditing,
                    nameController: _nameController,
                    emailController: _emailController,
                    formKey: _formKey,
                    sendEmailVerification: sendEmailVerification,
                    sendPasswordReset: sendPasswordReset,
                    cancelEdit: cancelEdit,
                    saveChanges: saveChanges,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
