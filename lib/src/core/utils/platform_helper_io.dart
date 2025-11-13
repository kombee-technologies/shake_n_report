import 'dart:io' show Platform;

/// Implementation for platforms with dart:io (Android/iOS)
class PlatformHelperImpl {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
}

