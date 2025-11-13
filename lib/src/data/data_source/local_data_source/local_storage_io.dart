import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implementation of LocalStorage using FlutterSecureStorage for mobile platforms
class LocalStorageImpl {
  late FlutterSecureStorage _secureStorage;

  LocalStorageImpl() {
    const AndroidOptions getAndroidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    );
    _secureStorage = const FlutterSecureStorage(aOptions: getAndroidOptions);
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  Future<void> clearKey(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<String> getStringData(String key) async =>
      await _secureStorage.read(key: key) ?? '';

  Future<void> setStringData(String key, String value) async =>
      await _secureStorage.write(key: key, value: value);

  Future<bool> getBoolData(String key, {bool defaultVal = false}) async =>
      bool.parse(await _secureStorage.read(key: key) ?? '$defaultVal');

  // ignore: avoid_positional_boolean_parameters
  Future<void> setBoolData(String key, bool value) async =>
      await _secureStorage.write(key: key, value: '$value');

  Future<double> getDoubleData(String key) async =>
      double.parse(await _secureStorage.read(key: key) ?? '0.0');

  Future<void> setDoubleData(String key, double value) async =>
      await _secureStorage.write(key: key, value: value.toString());

  Future<int> getIntegerData(String key) async =>
      int.parse(await _secureStorage.read(key: key) ?? '0');

  Future<void> setIntegerData(String key, int value) async =>
      await _secureStorage.write(key: key, value: value.toString());
}
