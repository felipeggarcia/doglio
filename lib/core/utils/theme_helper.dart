/// Theme Helper Extension
///
/// Provides easy access to the current theme's color scheme and text styles.
/// Usage: context.colors.primary  /  context.textStyles.bodyMedium
library;

import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
