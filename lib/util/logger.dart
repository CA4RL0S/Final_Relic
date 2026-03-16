import 'package:flutter/foundation.dart';

/// Sistema de logging para el juego
///
/// Este logger reemplaza los `print()` statements en todo el código.
/// Solo imprime mensajes en modo debug para mejorar el rendimiento
/// en producción.

class GameLogger {
  // Solo habilitar logs en modo debug
  static const bool _enableLogs = kDebugMode;

  /// Log informativo (ℹ️)
  /// Usar para información general de flujo del juego
  static void info(String message) {
    if (_enableLogs) {
      debugPrint('ℹ️ $message');
    }
  }

  /// Log de éxito (✅)
  /// Usar cuando algo se completa correctamente
  static void success(String message) {
    if (_enableLogs) {
      debugPrint('✅ $message');
    }
  }

  /// Log de error (❌)
  /// Usar para errores y excepciones
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_enableLogs) {
      final errorMsg = error != null ? ': $error' : '';
      debugPrint('❌ $message$errorMsg');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
    // En producción, aquí podrías enviar a un servicio de crashlytics
    // if (!kDebugMode && error != null) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // }
  }

  /// Log de advertencia (⚠️)
  /// Usar para situaciones potencialmente problemáticas
  static void warning(String message) {
    if (_enableLogs) {
      debugPrint('⚠️ $message');
    }
  }

  /// Log de debug (🐛)
  /// Usar para debugging detallado durante desarrollo
  static void debug(String message) {
    if (_enableLogs) {
      debugPrint('🐛 $message');
    }
  }

  /// Log de inicio de juego (🎮)
  /// Usar para eventos importantes del juego
  static void game(String message) {
    if (_enableLogs) {
      debugPrint('🎮 $message');
    }
  }

  /// Log de anuncios (📱)
  /// Usar para eventos relacionados con AdMob
  static void ads(String message) {
    if (_enableLogs) {
      debugPrint('📱 $message');
    }
  }

  /// Log de audio (🔊)
  /// Usar para eventos de audio
  static void audio(String message) {
    if (_enableLogs) {
      debugPrint('🔊 $message');
    }
  }

  /// Log de limpieza (🧹)
  /// Usar para dispose y cleanup
  static void cleanup(String message) {
    if (_enableLogs) {
      debugPrint('🧹 $message');
    }
  }
}
