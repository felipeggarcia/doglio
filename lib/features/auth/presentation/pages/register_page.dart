/// Registration page for Doglio Marketplace
///
/// This page handles new user account creation.
/// Users can register as customers or select admin role if authorized.
library;

import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/doglio_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/router.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_logo_section.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      _showMessage('Please accept the terms and conditions', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showMessage('Account created successfully!');
        // Navigate to login page
        context.goToLogin();
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Registration failed. Please try again.', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: AuthLoadingOverlay(
          isLoading: _isLoading,
          message: 'Creating your account...',
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Section
                      const AuthLogoSection(size: 180),

                      const SizedBox(height: 24),

                      // Welcome Text
                      _buildWelcomeSection(theme),

                      const SizedBox(height: 32),

                      // Registration Form
                      _buildRegistrationForm(theme),

                      const SizedBox(height: 24),

                      // Social Registration
                      _buildSocialSection(theme),

                      const SizedBox(height: 24),

                      // Login Link
                      _buildLoginSection(theme),
                    ],
                  ),
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
          'Join Doglio',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Create your account to start shopping',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Full Name Field
            _buildNameField(),

            const SizedBox(height: 20),

            // Email Field
            _buildEmailField(),

            const SizedBox(height: 20),

            // Password Field
            _buildPasswordField(),

            const SizedBox(height: 20),

            // Confirm Password Field
            _buildConfirmPasswordField(),

            const SizedBox(height: 20),

            // Terms and Conditions
            _buildTermsSection(theme),

            const SizedBox(height: 24),

            // Register Button
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return AuthFormField(
      controller: _nameController,
      label: 'Full Name',
      hint: 'Enter your full name',
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      validator: (value) => Validators.required(value, 'Full name'),
    );
  }

  Widget _buildEmailField() {
    return AuthFormField(
      controller: _emailController,
      label: 'Email',
      hint: 'Enter your email address',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.email,
    );
  }

  Widget _buildPasswordField() {
    return AuthFormField(
      controller: _passwordController,
      label: 'Password',
      hint: 'Create a strong password',
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: Validators.password,
    );
  }

  Widget _buildConfirmPasswordField() {
    return AuthFormField(
      controller: _confirmPasswordController,
      label: 'Confirm Password',
      hint: 'Confirm your password',
      prefixIcon: Icons.lock_outline,
      obscureText: _obscureConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
      validator: _validateConfirmPassword,
    );
  }

  Widget _buildTermsSection(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return DoglioButton(
      text: 'Create Account',
      onPressed: _isLoading ? null : _handleRegister,
      type: DoglioButtonType.primary,
      size: DoglioButtonSize.large,
      isLoading: _isLoading,
    );
  }

  Widget _buildSocialSection(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Or register with',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Social Login Buttons
        _buildSocialButtons(),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        SocialLoginButton(
          provider: SocialProvider.google,
          onPressed: _isLoading
              ? null
              : () {
                  _showMessage('Google registration coming soon!');
                },
          isLoading: false,
        ),
        const SizedBox(height: 8),
        SocialLoginButton(
          provider: SocialProvider.apple,
          onPressed: _isLoading
              ? null
              : () {
                  _showMessage('Apple registration coming soon!');
                },
          isLoading: false,
        ),
      ],
    );
  }

  Widget _buildLoginSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? ', style: theme.textTheme.bodyMedium),
        GestureDetector(
          onTap: () => context.goToLogin(),
          child: Text(
            'Sign In',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      title: Text(
        'Create Account',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }
}
