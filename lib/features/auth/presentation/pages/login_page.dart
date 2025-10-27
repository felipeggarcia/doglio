/// Login page for Doglio Marketplace
///
/// This page handles authentication for both customers and admins.
/// The system automatically determines user type based on role in database.
library;

import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/doglio_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/router.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_logo_section.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _authController.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    _authController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_authController.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: AppColors.success,
        ),
      );
      // TODO: Navigate to main app
    }
  }

  void _navigateToRegister() {
    context.goToRegister();
  }

  void _handleForgotPassword() {
    context.pushForgotPassword();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo Section
                    const AuthLogoSection(size: 250, showAppName: true),

                    const SizedBox(height: 24),

                    // Welcome Text
                    _buildWelcomeSection(theme),

                    const SizedBox(height: 32),

                    // Login Form
                    _buildLoginForm(theme),

                    const SizedBox(height: 24),

                    // Login Button
                    _buildLoginButton(),

                    const SizedBox(height: 16),

                    // Forgot Password
                    _buildForgotPasswordButton(theme),

                    const SizedBox(height: 32),

                    // Register Link
                    _buildRegisterSection(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Sign in to access your account',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Column(
      children: [
        // Email Field
        AuthFormField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: Validators.email,
          enabled: !_authController.isLoading,
        ),

        const SizedBox(height: 16),

        // Password Field
        AuthFormField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          validator: (value) => Validators.required(value, 'Password'),
          enabled: !_authController.isLoading,
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return DoglioButton(
      text: _authController.isLoading ? 'Signing in...' : 'Sign In',
      onPressed: _authController.isLoading ? null : _handleLogin,
      type: DoglioButtonType.primary,
      size: DoglioButtonSize.large,
      isLoading: _authController.isLoading,
      fullWidth: true,
    );
  }

  Widget _buildForgotPasswordButton(ThemeData theme) {
    return TextButton(
      onPressed: _authController.isLoading ? null : _handleForgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRegisterSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _authController.isLoading ? null : _navigateToRegister,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
