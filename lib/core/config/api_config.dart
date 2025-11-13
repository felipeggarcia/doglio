/// API configuration for Doglio app
///
/// This file contains the configuration for connecting to the Laravel backend.
library;

class ApiConfig {
  /// Base URL for the Laravel API
  /// 
  /// Development: Use your local Laravel server
  /// Production: Use your deployed API URL
  static const String baseUrl = 'http://localhost:8000'; // or 'http://10.0.2.2:8000' for Android emulator
  
  /// API timeout duration
  static const Duration timeout = Duration(seconds: 30);
  
  /// Enable debug mode for detailed logging
  static const bool debugMode = true;
}