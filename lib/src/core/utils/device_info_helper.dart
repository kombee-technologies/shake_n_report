// Conditional import: only import device_info_plus when dart:io is available
import 'package:shake_n_report/src/core/utils/device_info_helper_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/core/utils/device_info_helper_io.dart';

/// Helper class to get Android SDK version without breaking WASM compatibility
/// Returns null on non-Android platforms or when dart:io is not available
class DeviceInfoHelper {
  /// Get Android SDK version (returns null on non-Android platforms or web/WASM)
  static Future<int?> getAndroidSdkVersion() => 
      DeviceInfoHelperImpl.getAndroidSdkVersion();
}

