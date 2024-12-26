import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;

class Logger {
  static final _logger = log.Logger(
    printer: log.PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void pageBuild(String pageName) {
    if (kDebugMode) {
      _logger.i('🏗️ Building page: $pageName');
    }
  }

  static void pageDispose(String pageName) {
    if (kDebugMode) {
      _logger.d('🗑️ Disposing page: $pageName');
    }
  }

  static void pageInit(String pageName) {
    if (kDebugMode) {
      _logger.i('🚀 Initializing page: $pageName');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e('❌ Error: $message', error: error, stackTrace: stackTrace);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _logger.w('⚠️ Warning: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      _logger.i('ℹ️ Info: $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      _logger.d('🔍 Debug: $message');
    }
  }
}
