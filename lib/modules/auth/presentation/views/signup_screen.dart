import 'package:blog_app/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/core/core.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.surface,
      appBar: CustomAppBarWidget(
        title: Text(
          "Blog App",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.customTheme.background,
        showBackButton: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(Routes.authWrapper.name);
          } else if (state is AuthSignUpSuccess) {
            context.goNamed(Routes.authWrapper.name);
            CustomSnackbar.showToastMessage(
              type: ToastType.success,
              message: state.message,
            );
          } else if (state is AuthError) {
            context.goNamed(Routes.authWrapper.name);
            CustomSnackbar.showToastMessage(
              type: ToastType.error,
              message: state.message,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Account',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  AppGaps.gapH40,

                  TextFormField(
                    style: context.textTheme.bodyMedium,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => Validators.checkFieldEmpty(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                      labelStyle: context.textTheme.bodyMedium,
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                  ),

                  AppGaps.gapH16,

                  TextFormField(
                    style: context.textTheme.bodyMedium,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Validators.checkEmailField(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: context.textTheme.bodyMedium,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  AppGaps.gapH16,

                  TextFormField(
                    style: context.textTheme.bodyMedium,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (value) => Validators.checkPasswordField(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: context.textTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          );
                        },
                      ),
                    ),
                  ),

                  AppGaps.gapH16,

                  TextFormField(
                    style: context.textTheme.bodyMedium,
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) => Validators.checkConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      labelStyle: context.textTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(
                            () => _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible,
                          );
                        },
                      ),
                    ),
                  ),

                  AppGaps.gapH16,

                  EmailAuthButton(isLogin: false, authentication: signUp),

                  AppGaps.gapH24,

                  AuthDivider(),

                  AppGaps.gapH24,

                  GoogleAuthentication(),

                  AppGaps.gapH24,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.customTheme.contentPrimary,
                        ),
                      ),
                      CustomButton.text(
                        label: 'Sign In',
                        onTap: () {
                          context.goNamed(Routes.login.name);
                        },
                        textColor: context.customTheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
