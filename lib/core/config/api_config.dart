/// API configuration for Doglio app
library;

import 'environment.dart';

class ApiConfig {
  /// Base URL — delegates to EnvironmentConfig.
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;

  /// Base URL for storage assets (images, files, etc)
  static String get baseStorageUrl => EnvironmentConfig.storageBaseUrl;

  /// Laragon virtual host — enviado como header Host para o Apache rotear corretamente.
  static const String virtualHost = 'doglio_backend.test';

  /// Timeout das requisições
  static Duration get timeout => EnvironmentConfig.apiTimeout;

  /// Normaliza URLs de imagens da API substituindo o domínio virtual pelo IP do emulador.
  static String normalizeImageUrl(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('http')) {
      return url.replaceFirst(RegExp(r'https?://[^/]+'), baseStorageUrl);
    }
    return '$baseStorageUrl$url';
  }
}
