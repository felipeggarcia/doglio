/// Typography system for Doglio Marketplace
///
/// This file defines the complete font system including font families,
/// weights, and text styles used throughout the application.
library;

import 'package:flutter/material.dart';

class AppFonts {
  // Font Families
  static const String primaryFontFamily = 'Roboto';
  static const String secondaryFontFamily = 'Poppins';
  static const String displayFontFamily = 'Poppins';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Font Sizes
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize22 = 22.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize48 = 48.0;

  // Line Heights
  static const double lineHeight1_2 = 1.2;
  static const double lineHeight1_3 = 1.3;
  static const double lineHeight1_4 = 1.4;
  static const double lineHeight1_5 = 1.5;
  static const double lineHeight1_6 = 1.6;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingExtraWide = 1.0;
}

/// Text styles for the application
class AppTextStyles {
  // Display Styles (Large headings)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.displayFontFamily,
    fontSize: AppFonts.fontSize48,
    fontWeight: AppFonts.bold,
    height: AppTextStyles.lineHeightDisplayLarge,
    letterSpacing: AppFonts.letterSpacingTight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.displayFontFamily,
    fontSize: AppFonts.fontSize36,
    fontWeight: AppFonts.bold,
    height: AppTextStyles.lineHeightDisplayMedium,
    letterSpacing: AppFonts.letterSpacingTight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.displayFontFamily,
    fontSize: AppFonts.fontSize32,
    fontWeight: AppFonts.semiBold,
    height: AppTextStyles.lineHeightDisplaySmall,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize28,
    fontWeight: AppFonts.semiBold,
    height: AppTextStyles.lineHeightHeadlineLarge,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize24,
    fontWeight: AppFonts.semiBold,
    height: AppTextStyles.lineHeightHeadlineMedium,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize22,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightHeadlineSmall,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize20,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightTitleLarge,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize18,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightTitleMedium,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize16,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightTitleSmall,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize16,
    fontWeight: AppFonts.regular,
    height: AppTextStyles.lineHeightBodyLarge,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize14,
    fontWeight: AppFonts.regular,
    height: AppTextStyles.lineHeightBodyMedium,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize12,
    fontWeight: AppFonts.regular,
    height: AppTextStyles.lineHeightBodySmall,
    letterSpacing: AppFonts.letterSpacingNormal,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize14,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightLabelLarge,
    letterSpacing: AppFonts.letterSpacingWide,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize12,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightLabelMedium,
    letterSpacing: AppFonts.letterSpacingWide,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.primaryFontFamily,
    fontSize: AppFonts.fontSize10,
    fontWeight: AppFonts.medium,
    height: AppTextStyles.lineHeightLabelSmall,
    letterSpacing: AppFonts.letterSpacingWide,
  );

  // Line Heights (calculated from design specs)
  static const double lineHeightDisplayLarge = 1.2;
  static const double lineHeightDisplayMedium = 1.2;
  static const double lineHeightDisplaySmall = 1.3;
  static const double lineHeightHeadlineLarge = 1.3;
  static const double lineHeightHeadlineMedium = 1.3;
  static const double lineHeightHeadlineSmall = 1.4;
  static const double lineHeightTitleLarge = 1.4;
  static const double lineHeightTitleMedium = 1.4;
  static const double lineHeightTitleSmall = 1.5;
  static const double lineHeightBodyLarge = 1.5;
  static const double lineHeightBodyMedium = 1.5;
  static const double lineHeightBodySmall = 1.6;
  static const double lineHeightLabelLarge = 1.4;
  static const double lineHeightLabelMedium = 1.4;
  static const double lineHeightLabelSmall = 1.4;
}
