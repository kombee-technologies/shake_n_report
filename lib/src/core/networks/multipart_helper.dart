import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// A utility class for creating multipart requests with file uploads.
/// Handles file encoding, metadata, and multipart request construction.
class MultipartHelper {
  /// Creates a MultipartFile from a file path
  /// 
  /// [field] - The field name for the file in the multipart request
  /// [filePath] - The path to the file to upload
  /// 
  /// Returns a Future that resolves to a MultipartFile
  static Future<http.MultipartFile> fileFromPath(
    String field,
    String filePath,
  ) async {
    final File file = File(filePath);
    final String fileName = file.path.split('/').last;
    
    // Detect MIME type from file extension
    final String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final List<String> mimeTypeParts = mimeType.split('/');
    
    return http.MultipartFile.fromPath(
      field,
      filePath,
      filename: fileName,
      contentType: mimeTypeParts.length == 2
          ? MediaType(mimeTypeParts[0], mimeTypeParts[1])
          : null,
    );
  }

  /// Creates a multipart request with files and fields
  /// 
  /// [method] - HTTP method (typically 'POST')
  /// [url] - The URL to send the request to
  /// [files] - List of MultipartFile objects to upload
  /// [fields] - Optional map of string fields to include in the request
  /// 
  /// Returns a configured MultipartRequest
  static http.MultipartRequest createRequest(
    String method,
    String url,
    List<http.MultipartFile> files,
    Map<String, String>? fields,
  ) {
    final Uri uri = Uri.parse(url);
    final http.MultipartRequest request = http.MultipartRequest(method, uri);

    // Add files to request
    request.files.addAll(files);

    // Add fields to request
    if (fields != null) {
      request.fields.addAll(fields);
    }

    return request;
  }

  /// Creates MultipartFile objects from a list of file paths
  /// 
  /// [field] - The field name for the files in the multipart request
  /// [filePaths] - List of file paths to convert
  /// 
  /// Returns a Future that resolves to a list of MultipartFile objects
  static Future<List<http.MultipartFile>> filesFromPaths(
    String field,
    List<String> filePaths,
  ) async {
    final List<http.MultipartFile> files = <http.MultipartFile>[];
    
    for (final String filePath in filePaths) {
      final http.MultipartFile file = await fileFromPath(field, filePath);
      files.add(file);
    }
    
    return files;
  }
}
