/// Global constants for Doglio Marketplace
///
/// This file centralizes all constants that define the behavior
/// and appearance of the pet products marketplace.
library;

class AppConstants {
  // App Information
  static const String appName = 'Doglio';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Pet products marketplace';

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double productCardHeight = 280.0;

  // Data Limits
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 1000;
  static const int maxReviewLength = 500;
  static const int productsPerPage = 20;
  static const int maxImagesPerProduct = 5;

  // Marketplace Colors
  static const int primaryColorValue = 0xFF2E7D32; // Pet-friendly green
  static const int accentColorValue = 0xFFFF8F00; // Orange for CTAs
  static const int successColorValue = 0xFF4CAF50; // Success green
  static const int errorColorValue = 0xFFF44336; // Error red

  // Supported Languages
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'pt'];
}

class DatabaseConstants {
  // Firestore Collections
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String favoritesCollection = 'favorites';

  // Common Fields
  static const String idField = 'id';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String isActiveField = 'isActive';
}

class RouteConstants {
  // Public Routes
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String catalog = '/catalog';
  static const String productDetails = '/product';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Authenticated Routes
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String favorites = '/favorites';

  // Admin Routes
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
}
