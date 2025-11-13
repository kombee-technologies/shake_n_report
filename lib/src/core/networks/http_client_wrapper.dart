// ignore_for_file: avoid_annotating_with_dynamic, always_specify_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/core/networks/http_response.dart';
import 'package:shake_n_report/src/core/networks/http_logger.dart';
import 'package:shake_n_report/src/core/networks/http_error_handler.dart';
import 'package:shake_n_report/src/core/networks/multipart_helper.dart';

/// A centralized HTTP client wrapper that provides Dio-like functionality
/// using dart:io HttpClient. Handles requests, responses, errors,
/// logging, and multipart uploads.
class HttpClientWrapper {
  static final HttpClientWrapper _instance = HttpClientWrapper._internal();
  static HttpClientWrapper get instance => _instance;

  final HttpClient _client;
  final HttpErrorHandler _errorHandler;
  final Duration connectionTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  /// Default headers applied to all requests
  final Map<String, String> _defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  HttpClientWrapper._internal({
    LocalStorage? localStorage,
    HttpClient? client,
    Duration? connectionTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  })  : _client = client ?? HttpClient(),
        _errorHandler = HttpErrorHandler(localStorage ?? LocalStorage.instance),
        connectionTimeout = connectionTimeout ?? const Duration(seconds: 60),
        sendTimeout = sendTimeout ?? const Duration(seconds: 60),
        receiveTimeout = receiveTimeout ?? const Duration(seconds: 60);

  /// Performs a GET request
  ///
  /// [url] - The URL to request
  /// [headers] - Optional custom headers (merged with defaults)
  /// [queryParameters] - Optional query parameters to append to URL
  ///
  /// Returns a Future that resolves to HttpResponse of type T
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = _buildUri(url, queryParameters);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);

    HttpLogger.logRequest('GET', uri.toString(), mergedHeaders, null);

    try {
      final HttpClientRequest request =
          await _client.getUrl(uri).timeout(connectionTimeout);
      _setHeaders(request, mergedHeaders);

      final HttpClientResponse response =
          await request.close().timeout(receiveTimeout);
      final String responseBody = await response.transform(utf8.decoder).join();

      final Map<String, String> responseHeaders = <String, String>{};
      response.headers.forEach((String name, List<String> values) {
        responseHeaders[name] = values.join(', ');
      });

      return _processResponse<T>(
        responseBody,
        response.statusCode,
        responseHeaders,
        response.reasonPhrase,
        uri.toString(),
      );
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, null, null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a POST request
  ///
  /// [url] - The URL to request
  /// [data] - The request body (will be JSON encoded if it's a Map or List)
  /// [headers] - Optional custom headers (merged with defaults)
  ///
  /// Returns a Future that resolves to HttpResponse of type T
  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);
    final String body = _encodeBody(data, mergedHeaders);

    HttpLogger.logRequest('POST', uri.toString(), mergedHeaders, data);

    try {
      final HttpClientRequest request =
          await _client.postUrl(uri).timeout(connectionTimeout);
      _setHeaders(request, mergedHeaders);

      if (body.isNotEmpty) {
        request.write(body);
      }

      final HttpClientResponse response =
          await request.close().timeout(receiveTimeout);
      final String responseBody = await response.transform(utf8.decoder).join();

      final Map<String, String> responseHeaders = <String, String>{};
      response.headers.forEach((String name, List<String> values) {
        responseHeaders[name] = values.join(', ');
      });

      return _processResponse<T>(
        responseBody,
        response.statusCode,
        responseHeaders,
        response.reasonPhrase,
        uri.toString(),
      );
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, null, null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a PUT request
  ///
  /// [url] - The URL to request
  /// [data] - The request body (will be JSON encoded if it's a Map or List)
  /// [headers] - Optional custom headers (merged with defaults)
  ///
  /// Returns a Future that resolves to HttpResponse of type T
  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);
    final String body = _encodeBody(data, mergedHeaders);

    HttpLogger.logRequest('PUT', uri.toString(), mergedHeaders, data);

    try {
      final HttpClientRequest request =
          await _client.putUrl(uri).timeout(connectionTimeout);
      _setHeaders(request, mergedHeaders);

      if (body.isNotEmpty) {
        request.write(body);
      }

      final HttpClientResponse response =
          await request.close().timeout(receiveTimeout);
      final String responseBody = await response.transform(utf8.decoder).join();

      final Map<String, String> responseHeaders = <String, String>{};
      response.headers.forEach((String name, List<String> values) {
        responseHeaders[name] = values.join(', ');
      });

      return _processResponse<T>(
        responseBody,
        response.statusCode,
        responseHeaders,
        response.reasonPhrase,
        uri.toString(),
      );
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, null, null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a multipart POST request for file uploads
  ///
  /// [url] - The URL to request
  /// [files] - List of MultipartFileData objects to upload
  /// [fields] - Optional string fields to include in the request
  /// [headers] - Optional custom headers (merged with defaults, excluding Content-Type)
  ///
  /// Returns a Future that resolves to HttpResponse of type T
  Future<HttpResponse<T>> postMultipart<T>(
    String url, {
    required List<MultipartFileData> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);

    HttpLogger.logRequest(
      'POST (multipart)',
      uri.toString(),
      headers ?? <String, String>{},
      'Files: ${files.length}, Fields: ${fields?.length ?? 0}',
    );

    try {
      final String boundary =
          'dart-http-boundary-${DateTime.now().millisecondsSinceEpoch}';
      final HttpClientRequest request =
          await _client.postUrl(uri).timeout(connectionTimeout);

      // Set headers (excluding Content-Type as it's set by multipart request)
      (headers ?? <String, String>{}).forEach((String key, String value) {
        if (key.toLowerCase() != 'content-type') {
          request.headers.set(key, value);
        }
      });

      request.headers
          .set('Content-Type', 'multipart/form-data; boundary=$boundary');

      // Write multipart body
      final IOSink sink = request;
      await MultipartHelper.writeMultipartBody(sink, boundary, files, fields);

      final HttpClientResponse response =
          await request.close().timeout(receiveTimeout);
      final String responseBody = await response.transform(utf8.decoder).join();

      final Map<String, String> responseHeaders = <String, String>{};
      response.headers.forEach((String name, List<String> values) {
        responseHeaders[name] = values.join(', ');
      });

      return _processResponse<T>(
        responseBody,
        response.statusCode,
        responseHeaders,
        response.reasonPhrase,
        uri.toString(),
      );
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, null, null, error, stackTrace);
      rethrow;
    }
  }

  /// Builds a URI with query parameters
  Uri _buildUri(String url, Map<String, dynamic>? queryParameters) {
    final Uri uri = Uri.parse(url);

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    // Convert query parameters to strings
    final Map<String, String> stringParams = queryParameters.map(
      (String key, value) => MapEntry(key, value.toString()),
    );

    return uri.replace(queryParameters: stringParams);
  }

  /// Merges custom headers with default headers
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    if (customHeaders == null) {
      return Map.from(_defaultHeaders);
    }

    return <String, String>{..._defaultHeaders, ...customHeaders};
  }

  /// Sets headers on the HttpClientRequest
  void _setHeaders(HttpClientRequest request, Map<String, String> headers) {
    headers.forEach((String key, String value) {
      request.headers.set(key, value);
    });
  }

  /// Encodes the request body based on Content-Type
  String _encodeBody(dynamic data, Map<String, String> headers) {
    if (data == null) {
      return '';
    }

    final String contentType = headers['Content-Type']?.toLowerCase() ?? '';

    // Handle form-encoded data
    if (contentType.contains('application/x-www-form-urlencoded')) {
      if (data is Map) {
        return data.entries
            .map((MapEntry<dynamic, dynamic> e) =>
                '${Uri.encodeComponent(e.key.toString())}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
      }
      return data.toString();
    }

    // Handle JSON data
    if (data is Map || data is List) {
      return jsonEncode(data);
    }

    // Return as string for other types
    return data.toString();
  }

  /// Processes HTTP response and handles errors
  Future<HttpResponse<T>> _processResponse<T>(
    String responseBody,
    int statusCode,
    Map<String, String> headers,
    String? reasonPhrase,
    String url,
  ) async {
    HttpLogger.logResponse(
      url,
      statusCode,
      headers,
      responseBody,
    );

    // Check for error status codes
    if (statusCode >= 400) {
      await _errorHandler.handleError(
          statusCode, headers, responseBody, null, StackTrace.current);
    }

    // Parse response body
    dynamic data;
    if (responseBody.isNotEmpty) {
      try {
        data = jsonDecode(responseBody);
      } catch (e) {
        // If JSON parsing fails, return raw body
        data = responseBody;
      }
    }

    return HttpResponse<T>(
      data: data as T?,
      statusCode: statusCode,
      headers: headers,
      statusMessage: reasonPhrase,
    );
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close(force: true);
  }
}
