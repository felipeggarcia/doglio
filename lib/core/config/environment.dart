/// Environment configuration for Doglio Marketplace
///
/// This file manages environment variables and API configurations
/// for different build environments (dev, staging, production).
library;

enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;

  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }

  // API Configuration
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8000';
      case Environment.staging:
        return 'https://api-staging.doglio.com';
      case Environment.production:
        return 'https://api.doglio.com';
    }
  }

  // API Timeout Configuration
  static int get apiTimeout {
    return 30; // seconds
  }

  static bool get enableApiLogging {
    return _currentEnvironment == Environment.development;
  }

  // Debug Configuration
  static bool get isDebugMode {
    return _currentEnvironment == Environment.development;
  }

  static bool get enableLogging {
    return _currentEnvironment != Environment.production;
  }

  // Payment Configuration (placeholder for future implementation)
  static String get stripePublishableKey {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'pk_test_dev_key';
      case Environment.staging:
        return 'pk_test_staging_key';
      case Environment.production:
        return 'pk_live_production_key';
    }
  }
}
