// ignore_for_file: avoid_annotating_with_dynamic

// Conditional import: only import dart:io when available
import 'package:shake_n_report/src/core/networks/http_error_handler_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/core/networks/http_error_handler_io.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';

/// A utility class that processes HTTP errors and converts them to appropriate exceptions.
/// Handles status code mapping, timeout errors, connection errors, and authentication failures.
/// Uses conditional imports to support mobile platforms (Android/iOS) and
/// provides limited error handling on web/WASM platforms.
class HttpErrorHandler {
  final LocalStorage localStorage;
  late HttpErrorHandlerImpl _impl;

  HttpErrorHandler(this.localStorage) {
    _impl = HttpErrorHandlerImpl(localStorage);
  }

  /// Handles HTTP errors and throws appropriate custom exceptions
  Future<void> handleError(
    int? statusCode,
    Map<String, String>? headers,
    String? responseBody,
    dynamic error,
    StackTrace stackTrace,
  ) async =>
      _impl.handleError(statusCode, headers, responseBody, error, stackTrace);
}
