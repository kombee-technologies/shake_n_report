import 'package:shake_n_report/src/core/networks/multipart_helper.dart';

/// Stub implementation of MultipartHelper for web/WASM platforms
/// Throws UnsupportedError since file operations are not available on web
class MultipartHelperImpl {
  static Future<MultipartFileData> fileFromPath(
    String field,
    String filePath,
  ) async {
    throw UnsupportedError(
      'MultipartHelper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  static Future<List<MultipartFileData>> filesFromPaths(
    String field,
    List<String> filePaths,
  ) async {
    throw UnsupportedError(
      'MultipartHelper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  static Future<void> writeMultipartBody(
    // ignore: avoid_annotating_with_dynamic
    dynamic sink,
    String boundary,
    List<MultipartFileData> files,
    Map<String, String>? fields,
  ) async {
    throw UnsupportedError(
      'MultipartHelper is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }
}
