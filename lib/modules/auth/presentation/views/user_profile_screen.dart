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

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> loadUserProfile() async {
    context.read<ProfileBloc>().add(ProfileLoadRequested());
  }

  UserProfileEntity? getUserProfile() {
    final state = context.read<ProfileBloc>().state;
    final profile = state is ProfileLoaded ? state.profile : null;
    return profile;
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();
      context.read<ProfileBloc>().add(
        ProfileUpdateDisplayNameRequested(displayName: newName),
      );
    }
  }

  void cancelEdit() {
    final profile = getUserProfile();
    setState(() {
      _isEditing = false;
      _nameController.text = profile?.displayName ?? '';
    });
  }

  void toggleEdit() {
    final profile = getUserProfile();
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _nameController.text = profile?.displayName ?? '';
      }
    });
  }

  void sendEmailVerification() {
    final profile = getUserProfile();
    if (profile?.emailVerified == true) {
      CustomSnackbar.showToastMessage(
        type: ToastType.info,
        message: "Email already Verified!",
      );
      return;
    }
    context.read<AccountBloc>().add(AccountSendEmailVerificationRequested());
  }

  void sendPasswordReset() {
    final profile = getUserProfile();
    final email = profile?.email;
    if (email != null) {
      context.read<AccountBloc>().add(
        AccountSendPasswordResetRequested(email: email),
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
      backgroundColor: context.customTheme.surface,
      appBar: CustomAppBarWidget(
        title: Text(
          "User Profile",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.customTheme.background,
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
          if (state is AuthUnauthenticated) {
            context.goNamed(Routes.authWrapper.name);
          } else if (state is AuthError) {
            context.goNamed(Routes.authWrapper.name);
            CustomSnackbar.showToastMessage(
              type: ToastType.error,
              message: state.message,
            );
          } else if (state is AuthInitial) {
            context.goNamed(Routes.authWrapper.name);
          }
        },
        child: BlocListener<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountEmailVerificationSent) {
              CustomSnackbar.showToastMessage(
                type: ToastType.success,
                message: state.message,
              );
            } else if (state is AccountPasswordResetSent) {
              CustomSnackbar.showToastMessage(
                type: ToastType.success,
                message: state.message,
              );
            } else if (state is AccountDeleted) {
              context.goNamed(Routes.authWrapper.name);
              CustomSnackbar.showToastMessage(
                type: ToastType.success,
                message: state.message,
              );
            } else if (state is AccountError) {
              context.goNamed(Routes.authWrapper.name);
              CustomSnackbar.showToastMessage(
                type: ToastType.error,
                message: state.message,
              );
            }
          },
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdated) {
                setState(() {
                  _isEditing = false;
                });
                loadUserProfile();
                CustomSnackbar.showToastMessage(
                  type: ToastType.success,
                  message: "Profile Updation Successsful!",
                );
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final profile = state is ProfileLoaded ? state.profile : null;
                if (profile != null && !_isEditing) {
                  _nameController.text = profile.displayName;
                  _emailController.text = profile.email;
                }
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(
                        userProfile: profile,
                        isEditing: _isEditing,
                      ),

                      AppGaps.gapH12,

                      ProfileFormSection(
                        userProfile: profile,
                        isEditing: _isEditing,
                        nameController: _nameController,
                        emailController: _emailController,
                        formKey: _formKey,
                        sendEmailVerification: sendEmailVerification,
                        sendPasswordReset: sendPasswordReset,
                        cancelEdit: cancelEdit,
                        saveChanges: saveChanges,
                      ),

                      AppGaps.gapH24,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
