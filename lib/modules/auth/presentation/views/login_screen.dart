import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthSignInRequested(
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
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CustomSnackbar.showToastMessage(
              type: ToastType.error,
              message: state.message,
            );
          }
          if (state is AuthAuthenticated) {
            context.goNamed(Routes.authWrapper.name);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    AppGaps.gapH4,

                    Text(
                      'Sign in to your account',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.customTheme.contentSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    AppGaps.gapH40,

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
                      validator: (value) =>
                          Validators.checkPasswordField(value),
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

                    AppGaps.gapH4,

                    ForgotPassword(),

                    AppGaps.gapH12,

                    EmailAuthButton(isLogin: true, authentication: signIn),

                    AppGaps.gapH24,

                    AuthDivider(),

                    AppGaps.gapH24,

                    GoogleAuthentication(),

                    AppGaps.gapH24,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.customTheme.contentPrimary,
                          ),
                        ),
                        CustomButton.text(
                          label: 'Sign Up',
                          onTap: () {
                            context.pushNamed(Routes.signup.name);
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
      ),
    );
  }
}
