/// Domain failures — erros tipados para toda a aplicação
/// Usa Dart 3 sealed classes para pattern matching exaustivo.
library;

sealed class Failure {
  const Failure();

  /// Mensagem amigável para exibir na UI
  String get userMessage => switch (this) {
    NetworkFailure() => 'Sem conexão. Verifique sua internet.',
    TimeoutFailure() => 'Tempo limite esgotado. Tente novamente.',
    ServerFailure(:final statusCode) =>
      'Erro no servidor ($statusCode). Tente mais tarde.',
    UnauthorizedFailure() => 'Sessão expirada. Faça login novamente.',
    ForbiddenFailure() => 'Acesso negado.',
    NotFoundFailure() => 'Recurso não encontrado.',
    ValidationFailure(:final errors) =>
      errors.values.expand((e) => e).join('\n'),
    UnknownFailure(:final message) => message,
    // Legacy subtypes kept por compatibilidade
    AuthFailure(:final message) => message,
    CacheFailure(:final message) => message,
  };
}

/// Sem conexão de rede
final class NetworkFailure extends Failure {
  const NetworkFailure([this.message = '']);
  final String message;
}

/// Timeout da requisição
final class TimeoutFailure extends Failure {
  const TimeoutFailure();
}

/// Erro HTTP do servidor (4xx/5xx)
final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode, this.message);
  final int statusCode;
  final String message;
}

/// 401 - token inválido ou expirado
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

/// 403 - sem permissão
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure();
}

/// 404 - recurso não existe
final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

/// Erros de validação (422)
final class ValidationFailure extends Failure {
  const ValidationFailure(this.errors);
  final Map<String, List<String>> errors;
}

/// Erro de autenticação genérico
final class AuthFailure extends Failure {
  const AuthFailure(this.message);
  final String message;
}

/// Falha de cache / storage local
final class CacheFailure extends Failure {
  const CacheFailure(this.message);
  final String message;
}

/// Erro desconhecido / inesperado
final class UnknownFailure extends Failure {
  const UnknownFailure(this.message);
  final String message;
}
