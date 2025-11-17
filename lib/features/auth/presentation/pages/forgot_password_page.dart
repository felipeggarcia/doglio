/// Forgot Password page for Doglio Marketplace
///
/// This page handles password reset requests.
/// Users enter their email to receive a password reset link.
library;

import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/doglio_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/router.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_logo_section.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate password reset API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });
        _showMessage('Password reset email sent successfully!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(
          'Failed to send reset email. Please try again.',
          isError: true,
        );
      }
    }
  }

  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);

    try {
      // Simulate resend email API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage('Password reset email sent again!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(
          'Failed to resend email. Please try again.',
          isError: true,
        );
      }
    }
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
          message: _emailSent ? 'Resending email...' : 'Sending reset email...',
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _emailSent
                    ? _buildEmailSentView(theme)
                    : _buildResetForm(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      title: Text(
        'Reset Password',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildResetForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo Section
          const AuthLogoSection(size: 180),

          const SizedBox(height: 24),

          // Title and Description
          _buildHeaderSection(theme),

          const SizedBox(height: 32),

          // Reset Form
          _buildFormCard(theme),

          const SizedBox(height: 24),

          // Back to Login Link
          _buildBackToLoginSection(theme),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Forgot Password?',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Email Field
          _buildEmailField(),

          const SizedBox(height: 24),

          // Send Reset Email Button
          _buildSendResetButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return AuthFormField(
      controller: _emailController,
      label: 'Email Address',
      hint: 'Enter your email address',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.email,
    );
  }

  Widget _buildSendResetButton() {
    return DoglioButton(
      text: 'Send Reset Link',
      onPressed: _isLoading ? null : _handleSendResetEmail,
      type: DoglioButtonType.primary,
      size: DoglioButtonSize.large,
      isLoading: _isLoading,
    );
  }

  Widget _buildBackToLoginSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Remember your password? ', style: theme.textTheme.bodyMedium),
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

  Widget _buildEmailSentView(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Icon
        _buildSuccessIcon(theme),

        const SizedBox(height: 32),

        // Success Title
        _buildSuccessTitle(theme),

        const SizedBox(height: 16),

        // Success Message
        _buildSuccessMessage(theme),

        const SizedBox(height: 24),

        // Instructions
        _buildInstructions(theme),

        const SizedBox(height: 32),

        // Action Buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSuccessIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle_outline,
        size: 80,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildSuccessTitle(ThemeData theme) {
    return Text(
      'Email Sent!',
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSuccessMessage(ThemeData theme) {
    return Column(
      children: [
        Text(
          'We\'ve sent a password reset link to:',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          _emailController.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Check your email and click the link to reset your password. The link will expire in 1 hour.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Resend Email Button
        _buildResendButton(),

        const SizedBox(height: 12),

        // Back to Login Button
        _buildBackToLoginButton(),
      ],
    );
  }

  Widget _buildResendButton() {
    return DoglioButton(
      text: 'Resend Email',
      onPressed: _isLoading ? null : _handleResendEmail,
      type: DoglioButtonType.outline,
      size: DoglioButtonSize.large,
      isLoading: _isLoading,
    );
  }

  Widget _buildBackToLoginButton() {
    return DoglioButton(
      text: 'Back to Sign In',
      onPressed: () => context.goToLogin(),
      type: DoglioButtonType.text,
      size: DoglioButtonSize.large,
    );
  }
}
