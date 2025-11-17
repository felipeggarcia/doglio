/// API configuration for Doglio app
///
/// This file contains the configuration for connecting to the Laravel backend.
library;

class ApiConfig {
  /// Base URL for the Laravel API
  ///
  /// Development: Use http://10.0.2.2:8000/api/v1 for Android emulator
  /// Production: Use your deployed API URL
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  /// API timeout duration
  static const Duration timeout = Duration(seconds: 30);

  /// Enable debug mode for detailed logging
  static const bool debugMode = true;
}
