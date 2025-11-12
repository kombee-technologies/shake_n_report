// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class that logs HTTP requests and responses in debug mode.
/// Provides formatted output with chunking for large responses.
class HttpLogger {
  static const int _chunkSize = 800;
  static const String _separator = '════════════════════════════════════════════════════════════════════════════════';

  /// Logs an HTTP request with method, URL, headers, and body
  static void logRequest(
    String method,
    String url,
    Map<String, String>? headers,
    dynamic body,
  ) {
    if (!kDebugMode) {
      return;
    }

    developer.log(_separator, name: 'HTTP');
    developer.log('📤 REQUEST', name: 'HTTP');
    developer.log('Method: $method', name: 'HTTP');
    developer.log('URL: $url', name: 'HTTP');

    if (headers != null && headers.isNotEmpty) {
      developer.log('Headers:', name: 'HTTP');
      headers.forEach((String key, String value) {
        developer.log('  $key: $value', name: 'HTTP');
      });
    }

    if (body != null) {
      developer.log('Body:', name: 'HTTP');
      _logChunked(body.toString());
    }

    developer.log(_separator, name: 'HTTP');
  }

  /// Logs an HTTP response with status code, headers, and body
  static void logResponse(
    String url,
    int statusCode,
    Map<String, String> headers,
    dynamic body,
  ) {
    if (!kDebugMode) {
      return;
    }

    developer.log(_separator, name: 'HTTP');
    developer.log('📥 RESPONSE', name: 'HTTP');
    developer.log('URL: $url', name: 'HTTP');
    developer.log('Status Code: $statusCode', name: 'HTTP');

    if (headers.isNotEmpty) {
      developer.log('Headers:', name: 'HTTP');
      headers.forEach((String key, String value) {
        developer.log('  $key: $value', name: 'HTTP');
      });
    }

    if (body != null) {
      developer.log('Body:', name: 'HTTP');
      _logChunked(body.toString());
    }

    developer.log(_separator, name: 'HTTP');
  }

  /// Logs an HTTP error with URL, error details, and stack trace
  static void logError(
    String url,
    dynamic error,
    StackTrace stackTrace,
  ) {
    if (!kDebugMode) {
      return;
    }

    developer.log(_separator, name: 'HTTP');
    developer.log('❌ ERROR', name: 'HTTP');
    developer.log('URL: $url', name: 'HTTP');
    developer.log('Error: $error', name: 'HTTP');
    developer.log('Stack Trace:', name: 'HTTP');
    _logChunked(stackTrace.toString());
    developer.log(_separator, name: 'HTTP');
  }

  /// Chunks large strings to avoid log truncation
  static void _logChunked(String text) {
    if (text.length <= _chunkSize) {
      developer.log(text, name: 'HTTP');
      return;
    }

    for (int i = 0; i < text.length; i += _chunkSize) {
      final int end = (i + _chunkSize < text.length) ? i + _chunkSize : text.length;
      developer.log(text.substring(i, end), name: 'HTTP');
    }
  }
}
