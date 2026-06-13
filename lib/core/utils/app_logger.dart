/// Centralised logging for Doglio.
///
/// Usage: AppLogger.d('msg'), AppLogger.e('msg', error, stackTrace)
/// Logging is suppressed in production builds automatically.
library;

import 'package:logger/logger.dart';
import '../config/environment.dart';

class AppLogger {
  AppLogger._();

  static Logger? _logger;

  static Logger get _instance => _logger ??= _buildLogger();

  static Logger _buildLogger() => Logger(
        level: EnvironmentConfig.enableLogging ? Level.debug : Level.off,
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 6,
          lineLength: 80,
          colors: false,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.none,
        ),
      );

  /// Call once at app startup to initialise with the correct environment level.
  static void init() => _logger = _buildLogger();

  static void d(String message, [Object? error]) => _instance.d(message, error: error);
  static void i(String message, [Object? error]) => _instance.i(message, error: error);
  static void w(String message, [Object? error]) => _instance.w(message, error: error);
  static void e(String message, [Object? error, StackTrace? stack]) =>
      _instance.e(message, error: error, stackTrace: stack);
}
