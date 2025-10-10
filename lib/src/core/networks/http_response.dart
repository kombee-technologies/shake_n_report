/// A generic HTTP response wrapper that provides type-safe access to response data.
class HttpResponse<T> {
  /// The response data, can be null if the response has no body
  final T? data;

  /// HTTP status code (e.g., 200, 404, 500)
  final int statusCode;

  /// Response headers
  final Map<String, String> headers;

  /// Optional status message
  final String? statusMessage;

  HttpResponse({
    this.data,
    required this.statusCode,
    required this.headers,
    this.statusMessage,
  });

  /// Returns true if the status code indicates success (200-299)
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
