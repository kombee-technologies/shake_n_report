// ignore_for_file: avoid_annotating_with_dynamic, always_specify_types

// Conditional import: only import dart:io when available
import 'package:shake_n_report/src/core/networks/http_client_wrapper_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/core/networks/http_client_wrapper_io.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/core/networks/http_response.dart';
import 'package:shake_n_report/src/core/networks/multipart_helper.dart';

/// A centralized HTTP client wrapper that provides Dio-like functionality
/// using dart:io HttpClient. Handles requests, responses, errors,
/// logging, and multipart uploads.
/// Uses conditional imports to support mobile platforms (Android/iOS) and
/// throws UnsupportedError on web/WASM platforms.
class HttpClientWrapper {
  static final HttpClientWrapper _instance = HttpClientWrapper._internal();
  static HttpClientWrapper get instance => _instance;

  late HttpClientWrapperImpl _impl;
  final Duration connectionTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  HttpClientWrapper._internal({
    LocalStorage? localStorage,
    dynamic client,
    Duration? connectionTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  })  : connectionTimeout = connectionTimeout ?? const Duration(seconds: 60),
        sendTimeout = sendTimeout ?? const Duration(seconds: 60),
        receiveTimeout = receiveTimeout ?? const Duration(seconds: 60) {
    _impl = HttpClientWrapperImpl(
      localStorage: localStorage ?? LocalStorage.instance,
      client: client,
      connectionTimeout: connectionTimeout,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
    );
  }

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
  }) async =>
      _impl.get<T>(url, headers: headers, queryParameters: queryParameters);

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
  }) async =>
      _impl.post<T>(url, data: data, headers: headers);

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
  }) async =>
      _impl.put<T>(url, data: data, headers: headers);

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
  }) async =>
      _impl.postMultipart<T>(url,
          files: files, fields: fields, headers: headers);

  /// Disposes the HTTP client
  void dispose() {
    _impl.dispose();
  }
}
