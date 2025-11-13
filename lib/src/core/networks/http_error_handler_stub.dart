import 'dart:async';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';

/// Stub implementation of HttpErrorHandler for web/WASM platforms
class HttpErrorHandlerImpl {
  final LocalStorage localStorage;

  HttpErrorHandlerImpl(this.localStorage);

  /// Handles HTTP errors and throws appropriate custom exceptions
  Future<void> handleError(
    int? statusCode,
    Map<String, String>? headers,
    String? responseBody,
    // ignore: avoid_annotating_with_dynamic
    dynamic error,
    StackTrace stackTrace,
  ) async {
    // Handle timeout errors (TimeoutException is from dart:async, available on all platforms)
    if (error is TimeoutException) {
      throw TimeoutException(
          'Request timeout: Connection took too long to respond');
    }

    // Handle HTTP status code errors
    if (statusCode != null) {
      await _handleStatusCode(statusCode);
    }

    // Default to general exception for unknown errors
    throw GeneralException(
        'An unexpected error occurred: ${error?.toString() ?? 'Unknown error'}');
  }

  /// Maps HTTP status codes to appropriate exceptions
  Future<void> _handleStatusCode(int statusCode) async {
    switch (statusCode) {
      case 401:
      case 403:
        // Clear local storage on authentication failure
        await localStorage.clear();
        throw UnauthorizedException(
          'Authentication failed: Invalid or expired credentials (Status: $statusCode)',
        );

      case 404:
        throw RouteNotFoundException(
          'Resource not found: The requested endpoint does not exist (Status: 404)',
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 505:
        throw ServerException(
          'Server error: The server encountered an error (Status: $statusCode)',
        );

      default:
        if (statusCode >= 400 && statusCode < 500) {
          throw GeneralException(
            'Client error: Bad request (Status: $statusCode)',
          );
        } else if (statusCode >= 500) {
          throw ServerException(
            'Server error: Internal server error (Status: $statusCode)',
          );
        }
    }
  }
}
