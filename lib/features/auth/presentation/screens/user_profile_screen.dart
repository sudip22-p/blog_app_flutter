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
  bool _isEditing = false;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    // Always load profile when screen initializes
    _loadUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load profile if not already loaded or if we need to refresh
    if (userProfile == null) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    context.read<AuthBloc>().add(AuthLoadProfileRequested());
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form if canceling edit
        _nameController.text = userProfile?['displayName'] ?? '';
      }
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();
      context.read<AuthBloc>().add(
        AuthUpdateDisplayNameRequested(displayName: newName),
      );
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = userProfile?['displayName'] ?? '';
    });
  }

  void _sendEmailVerification() {
    // TODO: Implement email verification
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email verification sent!')));
  }

  void _sendPasswordReset() {
    // TODO: Implement password reset
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password reset email sent!')));
  }

  void _showLogoutDialog() {
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
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
          if (!_isEditing)
            IconButton(
              onPressed: _toggleEdit,
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
              _isEditing = false;
            });
            _loadUserProfile(); // Reload the profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
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
            // Show loading indicator if we're loading or profile is null
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
                  // Profile Header Section with Gradient
                  ProfileHeader(
                    colorScheme: colorScheme,
                    userProfile: userProfile,
                    isEditing: _isEditing,
                  ),

                  const SizedBox(height: 24),

                  // Profile Form Section
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
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
                              controller: _nameController,
                              enabled: _isEditing,
                              validator: _isEditing ? _validateName : null,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: const Icon(Icons.person),
                                filled: !_isEditing,
                                fillColor: _isEditing
                                    ? null
                                    : colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Email Field (Read-only)
                            TextFormField(
                              controller: _emailController,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                suffixIcon:
                                    userProfile?['emailVerified'] == true
                                    ? Icon(
                                        Icons.verified,
                                        color: colorScheme.secondary,
                                      )
                                    : Icon(
                                        Icons.warning,
                                        color: colorScheme.error,
                                      ),
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
                            if (!_isEditing) ...[
                              // Email Verification Button
                              if (userProfile?['emailVerified'] == false)
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _sendEmailVerification,
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
                                  onPressed: _sendPasswordReset,
                                  icon: const Icon(Icons.lock_reset),
                                  label: const Text('Reset Password'),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _showLogoutDialog,
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Logout'),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Danger Zone
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorScheme.error.withAlpha(128),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorScheme.errorContainer.withAlpha(
                                    128,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: colorScheme.error,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Danger Zone',
                                          style: TextStyle(
                                            color: colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Once you delete your account, there is no going back. Please be certain.',
                                      style: TextStyle(
                                        color: colorScheme.onErrorContainer,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _showDeleteAccountDialog,
                                        icon: const Icon(Icons.delete_forever),
                                        label: const Text('Delete Account'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: colorScheme.error,
                                          side: BorderSide(
                                            color: colorScheme.error.withAlpha(
                                              128,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Edit Mode Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _cancelEdit,
                                      icon: const Icon(Icons.close),
                                      label: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _saveChanges,
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.colorScheme,
    required this.userProfile,
    required bool isEditing,
  }) : _isEditing = isEditing;

  final ColorScheme colorScheme;
  final Map<String, dynamic>? userProfile;
  final bool _isEditing;

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
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: colorScheme.primary,
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
