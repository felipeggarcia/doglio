/// Asset paths for Doglio Marketplace
///
/// This file centralizes all asset paths used throughout the application
/// to avoid hardcoded strings and make maintenance easier.
library;

import 'package:flutter/material.dart';

class AppAssets {
  // Logo Assets
  static const String logo = 'assets/images/logo/logo.png';

  // App Icons
  static const String appIcon = 'assets/images/icons/app_icon.png';
  static const String splashIcon = 'assets/images/icons/splash_icon.png';

  // Illustrations for empty states
  static const String emptyCart = 'assets/images/illustrations/empty_cart.png';
  static const String noProducts =
      'assets/images/illustrations/no_products.png';
  static const String errorIllustration =
      'assets/images/illustrations/error_illustration.png';
  static const String noInternet =
      'assets/images/illustrations/no_internet.png';
  static const String noFavorites =
      'assets/images/illustrations/no_favorites.png';

  // Placeholder images
  static const String productPlaceholder =
      'assets/images/placeholders/product_placeholder.png';
  static const String userPlaceholder =
      'assets/images/placeholders/user_placeholder.png';

  // Category icons (if needed)
  static const String categoryFood = 'assets/images/categories/food.png';
  static const String categoryToys = 'assets/images/categories/toys.png';
  static const String categoryHygiene = 'assets/images/categories/hygiene.png';
  static const String categoryAccessories =
      'assets/images/categories/accessories.png';
  static const String categoryHealth = 'assets/images/categories/health.png';
}

/// Helper widget for displaying app logo
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to text logo if image fails
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'DOGLIO',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
