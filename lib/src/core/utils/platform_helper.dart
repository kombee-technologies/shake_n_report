// Conditional import: only import platform helper when dart:io is available
import 'package:shake_n_report/src/core/utils/platform_helper_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/core/utils/platform_helper_io.dart';

/// Helper class to check platform without breaking WASM compatibility
/// Returns false for platform checks on web/WASM where dart:io is not available
class PlatformHelper {
  /// Check if running on Android (returns false on web/WASM)
  static bool get isAndroid => PlatformHelperImpl.isAndroid;

  /// Check if running on iOS (returns false on web/WASM)
  static bool get isIOS => PlatformHelperImpl.isIOS;
}
