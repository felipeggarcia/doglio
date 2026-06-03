/// Custom button widget for Doglio Marketplace
library;

import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: _buildButton(colorScheme),
    );
  }

  Widget _buildButton(ColorScheme colorScheme) {
    return switch (type) {
      DoglioButtonType.primary => ElevatedButton(
          onPressed: _getOnPressed(),
          style: _getButtonStyle(colorScheme),
          child: _buildButtonChild(colorScheme),
        ),
      DoglioButtonType.secondary => FilledButton(
          onPressed: _getOnPressed(),
          style: _getButtonStyle(colorScheme),
          child: _buildButtonChild(colorScheme),
        ),
      DoglioButtonType.outline => OutlinedButton(
          onPressed: _getOnPressed(),
          style: _getButtonStyle(colorScheme),
          child: _buildButtonChild(colorScheme),
        ),
      DoglioButtonType.text => TextButton(
          onPressed: _getOnPressed(),
          style: _getButtonStyle(colorScheme),
          child: _buildButtonChild(colorScheme),
        ),
    };
  }

  Widget _buildButtonChild(ColorScheme colorScheme) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingColor(colorScheme),
          ),
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
    // disabled states use Material's surface/outline tones
    final disabledBg = colorScheme.onSurface.withValues(alpha: 0.12);
    final disabledFg = colorScheme.onSurface.withValues(alpha: 0.38);

    return switch (type) {
      DoglioButtonType.primary => ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? disabledBg : colorScheme.primary,
          foregroundColor: isDisabled ? disabledFg : colorScheme.onPrimary,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: isDisabled ? 0 : 2,
        ),
      DoglioButtonType.secondary => FilledButton.styleFrom(
          backgroundColor: isDisabled ? disabledBg : colorScheme.secondary,
          foregroundColor: isDisabled ? disabledFg : colorScheme.onSecondary,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      DoglioButtonType.outline => OutlinedButton.styleFrom(
          foregroundColor: isDisabled ? disabledFg : colorScheme.primary,
          side: BorderSide(
            color: isDisabled ? disabledBg : colorScheme.primary,
            width: 1,
          ),
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      DoglioButtonType.text => TextButton.styleFrom(
          foregroundColor: isDisabled ? disabledFg : colorScheme.primary,
          padding: padding,
          textStyle: textStyle,
        ),
    };
  }

  Color _getLoadingColor(ColorScheme colorScheme) => switch (type) {
        DoglioButtonType.primary => colorScheme.onPrimary,
        DoglioButtonType.secondary => colorScheme.onSecondary,
        DoglioButtonType.outline || DoglioButtonType.text => colorScheme.primary,
      };

  EdgeInsets _getPadding() => switch (size) {
        DoglioButtonSize.small =>
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        DoglioButtonSize.medium =>
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        DoglioButtonSize.large =>
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      };

  TextStyle _getTextStyle() => switch (size) {
        DoglioButtonSize.small => AppTextStyles.labelMedium,
        DoglioButtonSize.medium => AppTextStyles.labelLarge,
        DoglioButtonSize.large => AppTextStyles.titleSmall,
      };

  double _getIconSize() => switch (size) {
        DoglioButtonSize.small => 16,
        DoglioButtonSize.medium => 20,
        DoglioButtonSize.large => 24,
      };

  VoidCallback? _getOnPressed() =>
      (isDisabled || isLoading) ? null : onPressed;
}
