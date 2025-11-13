/// Stub implementation of LocalStorage for web/WASM platforms
/// Throws UnsupportedError since secure storage is not available on web
class LocalStorageImpl {
  LocalStorageImpl() {
    throw UnsupportedError(
      'LocalStorage is not supported on web/WASM platforms. '
      'This package is designed for Android and iOS only.',
    );
  }

  Future<void> clear() async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<void> clearKey(String key) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<String> getStringData(String key) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<void> setStringData(String key, String value) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<bool> getBoolData(String key, {bool defaultVal = false}) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setBoolData(String key, bool value) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<double> getDoubleData(String key) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<void> setDoubleData(String key, double value) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<int> getIntegerData(String key) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }

  Future<void> setIntegerData(String key, int value) async {
    throw UnsupportedError('LocalStorage is not supported on web/WASM');
  }
}
