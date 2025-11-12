// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';

/// A utility class that processes HTTP errors and converts them to appropriate exceptions.
/// Handles status code mapping, timeout errors, connection errors, and authentication failures.
class HttpErrorHandler {
  final LocalStorage localStorage;

  HttpErrorHandler(this.localStorage);

  /// Handles HTTP errors and throws appropriate custom exceptions
  Future<void> handleError(
    http.Response? response,
    dynamic error,
    StackTrace stackTrace,
  ) async {
    // Handle timeout errors
    if (error is TimeoutException) {
      throw TimeoutException('Request timeout: Connection took too long to respond');
    }

    // Handle socket/connection errors
    if (error is SocketException) {
      throw ConnectionErrorException('Connection error: Unable to connect to server');
    }

    // Handle TLS/SSL certificate errors
    if (error is HandshakeException || error is TlsException) {
      throw BadCertificateException('Certificate error: SSL/TLS handshake failed');
    }

    // Handle HTTP status code errors
    if (response != null) {
      await _handleStatusCode(response.statusCode);
    }

    // Default to general exception for unknown errors
    throw GeneralException('An unexpected error occurred: ${error.toString()}');
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
