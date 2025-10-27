/// Custom button widget for Doglio Marketplace
///
/// This file provides a reusable button component that follows
/// the design system and supports various button styles.
library;

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

enum DoglioButtonType { primary, secondary, outline, text }

enum DoglioButtonSize { small, medium, large }

class DoglioButton extends StatelessWidget {
  const DoglioButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = DoglioButtonType.primary,
    this.size = DoglioButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final DoglioButtonType type;
  final DoglioButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: _buildButton(colorScheme),
    );
  }

  Widget _buildButton(ColorScheme colorScheme) {
    final buttonStyle = _getButtonStyle(colorScheme);
    final child = _buildButtonChild();

    switch (type) {
      case DoglioButtonType.primary:
        return ElevatedButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: child,
        );
      case DoglioButtonType.secondary:
        return FilledButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: child,
        );
      case DoglioButtonType.outline:
        return OutlinedButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: child,
        );
      case DoglioButtonType.text:
        return TextButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: child,
        );
    }
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle(ColorScheme colorScheme) {
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    switch (type) {
      case DoglioButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.grey300 : AppColors.primary,
          foregroundColor: isDisabled ? AppColors.grey600 : AppColors.onPrimary,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isDisabled ? 0 : 2,
        );
      case DoglioButtonType.secondary:
        return FilledButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.grey300 : AppColors.secondary,
          foregroundColor: isDisabled
              ? AppColors.grey600
              : AppColors.onSecondary,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      case DoglioButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: isDisabled ? AppColors.grey600 : AppColors.primary,
          side: BorderSide(
            color: isDisabled ? AppColors.grey300 : AppColors.primary,
            width: 1,
          ),
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      case DoglioButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: isDisabled ? AppColors.grey600 : AppColors.primary,
          padding: padding,
          textStyle: textStyle,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case DoglioButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case DoglioButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case DoglioButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case DoglioButtonSize.small:
        return AppTextStyles.labelMedium;
      case DoglioButtonSize.medium:
        return AppTextStyles.labelLarge;
      case DoglioButtonSize.large:
        return AppTextStyles.titleSmall;
    }
  }

  double _getIconSize() {
    switch (size) {
      case DoglioButtonSize.small:
        return 16;
      case DoglioButtonSize.medium:
        return 20;
      case DoglioButtonSize.large:
        return 24;
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case DoglioButtonType.primary:
        return AppColors.onPrimary;
      case DoglioButtonType.secondary:
        return AppColors.onSecondary;
      case DoglioButtonType.outline:
      case DoglioButtonType.text:
        return AppColors.primary;
    }
  }

  VoidCallback? _getOnPressed() {
    if (isDisabled || isLoading) {
      return null;
    }
    return onPressed;
  }
}
