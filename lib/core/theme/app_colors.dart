/// Color palette for Doglio Marketplace
///
/// This file defines the complete color system used throughout
/// the application following Material Design principles.
library;

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Pet-friendly green palette
  static const Color primary = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF005005);

  // Secondary Colors - Orange for CTAs and highlights
  static const Color secondary = Color(0xFFFF8F00);
  static const Color secondaryLight = Color(0xFFFFC046);
  static const Color secondaryDark = Color(0xFFC56000);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic Colors for E-commerce
  static const Color inStock = success;
  static const Color outOfStock = error;
  static const Color lowStock = warning;
  static const Color discount = Color(0xFFE91E63);
  static const Color priceTag = Color(0xFF795548);

  // Border and Divider Colors
  static const Color border = grey300;
  static const Color divider = grey200;
  static const Color focusedBorder = primary;
  static const Color errorBorder = error;

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x1F000000);

  // Card and Container Colors
  static const Color cardBackground = surface;
  static const Color containerBackground = surfaceVariant;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
}
