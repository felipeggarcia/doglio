/// API configuration for Doglio app
library;

class ApiConfig {
  /// Base URL for the Laravel API (porta 80 - Laragon)
  static const String baseUrl = 'http://10.0.2.2/api/v1';

  /// Base URL for storage assets (images, files, etc)
  static const String baseStorageUrl = 'http://10.0.2.2';

  /// Laragon virtual host - enviado como header Host para o Apache rotear corretamente
  static const String virtualHost = 'doglio_backend.test';

  /// Timeout das requisições
  static const Duration timeout = Duration(seconds: 15);

  /// Debug mode
  static const bool debugMode = true;

  /// Normaliza URLs de imagens da API substituindo o domínio virtual pelo IP do emulador
  static String normalizeImageUrl(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('http')) {
      return url.replaceFirst(RegExp(r'https?://[^/]+'), baseStorageUrl);
    }
    return '$baseStorageUrl$url';
  }
}
