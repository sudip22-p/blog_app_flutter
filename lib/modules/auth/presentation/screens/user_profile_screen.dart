import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    //loading profile when screen initializes
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
      _isEditing = false;
      // _nameController.text = _userProfile?['displayName'] ?? '';
      _nameController.text = _userProfile?.displayName ?? '';
    });
  }

  void toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _nameController.text = _userProfile?.displayName ?? '';
      }
    });
  }

  void sendEmailVerification() {
    if (_userProfile?.emailVerified == true) {
      CustomSnackbar.showToastMessage(
        type: ToastType.info,
        message: "Email already Verified!",
      );
      return;
    }
    context.read<AuthBloc>().add(AuthSendEmailVerificationRequested());
  }

  void sendPasswordReset() {
    final email = _userProfile?.email;
    if (email != null) {
      context.read<AuthBloc>().add(
        AuthSendPasswordResetRequested(email: email),
      );
    } else {
      CustomSnackbar.showToastMessage(
        type: ToastType.error,
        message: "Provided Email doesn't exist!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.background,
      appBar: CustomAppBarWidget(
        title: Text(
          "User Profile",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.customTheme.surface,
        showBackButton: true,
        
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: toggleEdit,
              icon: Icon(
                Icons.edit_square,
                color: context.customTheme.contentSurface,
              ),
            ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileLoaded) {
            setState(() {
              _userProfile = UserProfile.fromJson(state.profile);
              _nameController.text = _userProfile?.displayName ?? '';
              _emailController.text = _userProfile?.email ?? '';
            });
          } else if (state is AuthProfileUpdated) {
            setState(() {
              _isEditing = false;
            });
            loadUserProfile();
            CustomSnackbar.showToastMessage(
              type: ToastType.success,
              message: "Profile Updation Successsful!",
            );
          } else if (state is AuthEmailVerificationSent) {
            CustomSnackbar.showToastMessage(
              type: ToastType.success,
              message: state.message,
            );
          } else if (state is AuthPasswordResetSent) {
            CustomSnackbar.showToastMessage(
              type: ToastType.success,
              message: state.message,
            );
          } else if (state is AuthAccountDeleted) {
            CustomSnackbar.showToastMessage(
              type: ToastType.success,
              message: state.message,
            );
            context.goNamed(Routes.authWrapper.name);
          } else if (state is AuthUnauthenticated) {
            context.goNamed(Routes.authWrapper.name);
          } else if (state is AuthError) {
            CustomSnackbar.showToastMessage(
              type: ToastType.error,
              message: state.message,
            );
          } else if (state is AuthInitial) {
            context.goNamed(Routes.authWrapper.name);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || _userProfile == null) {
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
                    userProfile: _userProfile!,
                    isEditing: _isEditing,
                  ),

                  const SizedBox(height: 24),

                  // Profile Form Section
                  ProfileFormSection(
                    userProfile: _userProfile!,
                    isEditing: _isEditing,
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
