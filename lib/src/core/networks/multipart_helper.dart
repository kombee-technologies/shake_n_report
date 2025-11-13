// Conditional import: only import dart:io when available
import 'package:shake_n_report/src/core/networks/multipart_helper_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/core/networks/multipart_helper_io.dart';

/// Data class for multipart file uploads
class MultipartFileData {
  final String field;
  final String filePath;
  final String fileName;
  final String? contentType;

  MultipartFileData({
    required this.field,
    required this.filePath,
    required this.fileName,
    this.contentType,
  });
}

/// A utility class for creating multipart requests with file uploads.
/// Handles file encoding, metadata, and multipart request construction.
/// Uses conditional imports to support mobile platforms (Android/iOS) and
/// throws UnsupportedError on web/WASM platforms.
class MultipartHelper {
  /// Creates a MultipartFileData from a file path
  ///
  /// [field] - The field name for the file in the multipart request
  /// [filePath] - The path to the file to upload
  ///
  /// Returns a Future that resolves to a MultipartFileData
  static Future<MultipartFileData> fileFromPath(
    String field,
    String filePath,
  ) async =>
      MultipartHelperImpl.fileFromPath(field, filePath);

  /// Creates MultipartFileData objects from a list of file paths
  ///
  /// [field] - The field name for the files in the multipart request
  /// [filePaths] - List of file paths to convert
  ///
  /// Returns a Future that resolves to a list of MultipartFileData objects
  static Future<List<MultipartFileData>> filesFromPaths(
    String field,
    List<String> filePaths,
  ) async =>
      MultipartHelperImpl.filesFromPaths(field, filePaths);

  /// Writes multipart body to an IOSink
  ///
  /// [sink] - The IOSink to write to (or compatible sink)
  /// [boundary] - The multipart boundary string
  /// [files] - List of MultipartFileData objects to upload
  /// [fields] - Optional map of string fields to include in the request
  static Future<void> writeMultipartBody(
    // ignore: avoid_annotating_with_dynamic
    dynamic sink,
    String boundary,
    List<MultipartFileData> files,
    Map<String, String>? fields,
  ) async =>
      MultipartHelperImpl.writeMultipartBody(sink, boundary, files, fields);
}
