library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared/widgets/doglio_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/config/router.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_logo_section.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pleaseAcceptTerms),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          acceptTerms: _acceptTerms,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.userMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Conta criada com sucesso!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.goToStoreHome();
      },
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return context.l10n.passwordsDoNotMatch;
    }
    return null;
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.primary),
    );
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
          message: context.l10n.signingIn,
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
                      const AuthLogoSection(size: 180),
                      const SizedBox(height: 24),
                      _buildWelcomeSection(theme),
                      const SizedBox(height: 32),
                      _buildRegistrationForm(theme),
                      const SizedBox(height: 24),
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
          context.l10n.joinDoglio,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.registerSubtitle,
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
            AuthFormField(
              controller: _nameController,
              label: context.l10n.fullName,
              hint: context.l10n.fullNameHint,
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              validator: (value) => Validators.name(value, context),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            AuthFormField(
              controller: _emailController,
              label: context.l10n.email,
              hint: context.l10n.emailHint,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value, context),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            AuthFormField(
              controller: _passwordController,
              label: context.l10n.password,
              hint: context.l10n.createPassword,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) => Validators.password(value, context),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            AuthFormField(
              controller: _confirmPasswordController,
              label: context.l10n.confirmPassword,
              hint: context.l10n.confirmPasswordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              validator: _validateConfirmPassword,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            _buildTermsSection(theme),
            const SizedBox(height: 24),
            DoglioButton(
              text: context.l10n.createAccount,
              onPressed: _isLoading ? null : _handleRegister,
              type: DoglioButtonType.primary,
              size: DoglioButtonSize.large,
              isLoading: _isLoading,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _acceptTerms = !_acceptTerms),
            child: Text.rich(
              TextSpan(
                text: 'Aceito os ',
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: context.l10n.termsOfService,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' e '),
                  TextSpan(
                    text: context.l10n.privacyPolicy,
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

  Widget _buildLoginSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.alreadyHaveAccount,
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: _isLoading ? null : context.goToLogin,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            context.l10n.signIn,
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
