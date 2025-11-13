// Conditional import: only import flutter_secure_storage when dart:io is available
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage_stub.dart'
    if (dart.library.io) 'package:shake_n_report/src/data/data_source/local_data_source/local_storage_io.dart';

/// LocalStorage class that provides secure storage functionality.
/// Uses FlutterSecureStorage on mobile platforms (Android/iOS) and
/// throws UnsupportedError on web/WASM platforms.
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  static LocalStorage get instance => _instance;

  late LocalStorageImpl _impl;

  // Singleton pattern
  LocalStorage._internal() {
    _impl = LocalStorageImpl();
  }

//<---------------------------- Clear Data -------------------------------------//

  Future<void> clear() async {
    await _impl.clear();
  }

  Future<void> clearKey(String key) async {
    await _impl.clearKey(key);
  }

//<---------------------------- String -------------------------------------//

  Future<String> getStringData(String key) async =>
      await _impl.getStringData(key);

  Future<void> setStringData(String key, String value) async =>
      await _impl.setStringData(key, value);

//<---------------------------- Bool -------------------------------------//

  Future<bool> getBoolData(String key, {bool defaultVal = false}) async =>
      await _impl.getBoolData(key, defaultVal: defaultVal);

  // ignore: avoid_positional_boolean_parameters
  Future<void> setBoolData(String key, bool value) async =>
      await _impl.setBoolData(key, value);

//<---------------------------- Double -------------------------------------//

  Future<double> getDoubleData(String key) async =>
      await _impl.getDoubleData(key);

  Future<void> setDoubleData(String key, double value) async =>
      await _impl.setDoubleData(key, value);

//<---------------------------- Int -------------------------------------//

  Future<int> getIntegerData(String key) async =>
      await _impl.getIntegerData(key);

  Future<void> setIntegerData(String key, int value) async =>
      await _impl.setIntegerData(key, value);
}
