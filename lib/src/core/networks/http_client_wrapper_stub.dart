import 'package:shake_n_report/src/core/networks/http_response.dart';
import 'package:shake_n_report/src/core/networks/multipart_helper.dart';

/// Stub implementation of HttpClientWrapper for web/WASM platforms
/// Throws UnsupportedError since HTTP client is not available on web
class HttpClientWrapperImpl {
  HttpClientWrapperImpl({
    // ignore: avoid_annotating_with_dynamic, avoid_unused_constructor_parameters
    required dynamic localStorage,
    // ignore: avoid_annotating_with_dynamic, avoid_unused_constructor_parameters
    dynamic client,
    // ignore: avoid_unused_constructor_parameters
    Duration? connectionTimeout,
    // ignore: avoid_unused_constructor_parameters
    Duration? sendTimeout,
    // ignore: avoid_unused_constructor_parameters
    Duration? receiveTimeout,
  }) {
    throw UnsupportedError(
      'HttpClientWrapper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    throw UnsupportedError(
      'HttpClientWrapper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  Future<HttpResponse<T>> post<T>(
    String url, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Map<String, String>? headers,
  }) async {
    throw UnsupportedError(
      'HttpClientWrapper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  Future<HttpResponse<T>> put<T>(
    String url, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Map<String, String>? headers,
  }) async {
    throw UnsupportedError(
      'HttpClientWrapper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  Future<HttpResponse<T>> postMultipart<T>(
    String url, {
    required List<MultipartFileData> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    throw UnsupportedError(
      'HttpClientWrapper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  void dispose() {
    // No-op for stub
  }
}
