import 'dart:io';

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
class MultipartHelper {
  /// Detects MIME type from file extension
  static String _detectMimeType(String filePath) {
    final String extension = filePath.split('.').last.toLowerCase();
    final Map<String, String> mimeTypes = <String, String>{
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'json': 'application/json',
      'xml': 'application/xml',
      'zip': 'application/zip',
    };
    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  /// Creates a MultipartFileData from a file path
  ///
  /// [field] - The field name for the file in the multipart request
  /// [filePath] - The path to the file to upload
  ///
  /// Returns a Future that resolves to a MultipartFileData
  static Future<MultipartFileData> fileFromPath(
    String field,
    String filePath,
  ) async {
    final File file = File(filePath);
    final String fileName = file.path.split('/').last;
    final String mimeType = _detectMimeType(filePath);

    return MultipartFileData(
      field: field,
      filePath: filePath,
      fileName: fileName,
      contentType: mimeType,
    );
  }

  /// Creates MultipartFileData objects from a list of file paths
  ///
  /// [field] - The field name for the files in the multipart request
  /// [filePaths] - List of file paths to convert
  ///
  /// Returns a Future that resolves to a list of MultipartFileData objects
  static Future<List<MultipartFileData>> filesFromPaths(
    String field,
    List<String> filePaths,
  ) async {
    final List<MultipartFileData> files = <MultipartFileData>[];

    for (final String filePath in filePaths) {
      final MultipartFileData file = await fileFromPath(field, filePath);
      files.add(file);
    }

    return files;
  }

  /// Writes multipart body to an IOSink
  ///
  /// [sink] - The IOSink to write to
  /// [boundary] - The multipart boundary string
  /// [files] - List of MultipartFileData objects to upload
  /// [fields] - Optional map of string fields to include in the request
  static Future<void> writeMultipartBody(
    IOSink sink,
    String boundary,
    List<MultipartFileData> files,
    Map<String, String>? fields,
  ) async {
    // Write fields first
    if (fields != null) {
      for (final MapEntry<String, String> entry in fields.entries) {
        sink
          ..write('--$boundary\r\n')
          ..write('Content-Disposition: form-data; name="${entry.key}"\r\n')
          ..write('\r\n')
          ..write('${entry.value}\r\n');
      }
    }

    // Write files
    for (final MultipartFileData file in files) {
      final File fileObj = File(file.filePath);
      // ignore: avoid_slow_async_io
      if (!await fileObj.exists()) {
        continue;
      }

      final List<int> fileBytes = await fileObj.readAsBytes();

      sink
        ..write('--$boundary\r\n')
        ..write('Content-Disposition: form-data; name="${file.field}"; filename="${file.fileName}"\r\n');
      if (file.contentType != null) {
        sink.write('Content-Type: ${file.contentType}\r\n');
      }
      sink
        ..write('\r\n')
        ..add(fileBytes)
        ..write('\r\n');
    }

    // Write closing boundary
    sink.write('--$boundary--\r\n');
    await sink.flush();
  }
}
