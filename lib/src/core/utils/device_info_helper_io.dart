import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

/// Implementation for platforms with dart:io (Android/iOS)
class DeviceInfoHelperImpl {
  static Future<int?> getAndroidSdkVersion() async {
    if (!Platform.isAndroid) {
      return null;
    }
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }
}
