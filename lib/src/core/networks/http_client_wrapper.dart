// ignore_for_file: avoid_annotating_with_dynamic, always_specify_types

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/core/networks/http_response.dart';
import 'package:shake_n_report/src/core/networks/http_logger.dart';
import 'package:shake_n_report/src/core/networks/http_error_handler.dart';
import 'package:shake_n_report/src/core/networks/multipart_helper.dart';

/// A centralized HTTP client wrapper that provides Dio-like functionality
/// using the standard http package. Handles requests, responses, errors,
/// logging, and multipart uploads.
class HttpClientWrapper {
  static final HttpClientWrapper _instance = HttpClientWrapper._internal();
  static HttpClientWrapper get instance => _instance;

  final http.Client _client;
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
    http.Client? client,
    Duration? connectionTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  })  : _client = client ?? http.Client(),
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
  /// Returns a Future that resolves to HttpResponse<T>
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = _buildUri(url, queryParameters);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);

    HttpLogger.logRequest('GET', uri.toString(), mergedHeaders, null);

    try {
      final http.Response response = await _client.get(uri, headers: mergedHeaders).timeout(connectionTimeout);

      return _processResponse<T>(response, uri.toString());
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a POST request
  ///
  /// [url] - The URL to request
  /// [data] - The request body (will be JSON encoded if it's a Map or List)
  /// [headers] - Optional custom headers (merged with defaults)
  ///
  /// Returns a Future that resolves to HttpResponse<T>
  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);
    final body = _encodeBody(data, mergedHeaders);

    HttpLogger.logRequest('POST', uri.toString(), mergedHeaders, data);

    try {
      final http.Response response = await _client.post(uri, headers: mergedHeaders, body: body).timeout(sendTimeout);

      return _processResponse<T>(response, uri.toString());
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a PUT request
  ///
  /// [url] - The URL to request
  /// [data] - The request body (will be JSON encoded if it's a Map or List)
  /// [headers] - Optional custom headers (merged with defaults)
  ///
  /// Returns a Future that resolves to HttpResponse<T>
  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);
    final Map<String, String> mergedHeaders = _mergeHeaders(headers);
    final body = _encodeBody(data, mergedHeaders);

    HttpLogger.logRequest('PUT', uri.toString(), mergedHeaders, data);

    try {
      final http.Response response = await _client.put(uri, headers: mergedHeaders, body: body).timeout(sendTimeout);

      return _processResponse<T>(response, uri.toString());
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, error, stackTrace);
      rethrow;
    }
  }

  /// Performs a multipart POST request for file uploads
  ///
  /// [url] - The URL to request
  /// [files] - List of MultipartFile objects to upload
  /// [fields] - Optional string fields to include in the request
  /// [headers] - Optional custom headers (merged with defaults, excluding Content-Type)
  ///
  /// Returns a Future that resolves to HttpResponse<T>
  Future<HttpResponse<T>> postMultipart<T>(
    String url, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);

    // Create multipart request
    final http.MultipartRequest request = MultipartHelper.createRequest('POST', url, files, fields);

    // Add headers (excluding Content-Type as it's set by multipart request)
    (headers ?? <String, String>{}).forEach((String key, String value) {
      if (key.toLowerCase() != 'content-type') {
        request.headers[key] = value;
      }
    });

    HttpLogger.logRequest(
      'POST (multipart)',
      uri.toString(),
      request.headers,
      'Files: ${files.length}, Fields: ${fields?.length ?? 0}',
    );

    try {
      final http.StreamedResponse streamedResponse = await request.send().timeout(sendTimeout);
      final http.Response response = await http.Response.fromStream(streamedResponse);

      return _processResponse<T>(response, uri.toString());
    } catch (error, stackTrace) {
      HttpLogger.logError(uri.toString(), error, stackTrace);
      await _errorHandler.handleError(null, error, stackTrace);
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

  /// Encodes the request body based on Content-Type
  dynamic _encodeBody(dynamic data, Map<String, String> headers) {
    if (data == null) {
      return null;
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
    http.Response response,
    String url,
  ) async {
    HttpLogger.logResponse(
      url,
      response.statusCode,
      response.headers,
      response.body,
    );

    // Check for error status codes
    if (response.statusCode >= 400) {
      await _errorHandler.handleError(response, null, StackTrace.current);
    }

    // Parse response body
    dynamic data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        // If JSON parsing fails, return raw body
        data = response.body;
      }
    }

    return HttpResponse<T>(
      data: data as T?,
      statusCode: response.statusCode,
      headers: response.headers,
      statusMessage: response.reasonPhrase,
    );
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
