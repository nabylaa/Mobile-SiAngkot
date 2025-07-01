import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  /// Inisialisasi SharedPreferences (panggil ini di main.dart sebelum digunakan)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Simpan String
  static Future<void> putString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  /// Ambil String
  static String? getString(String key, {String defaultValue = ""}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  /// Simpan Int
  static Future<void> putInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  /// Ambil Int
  static int? getInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  /// Simpan Boolean
  static Future<void> putBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  /// Ambil Boolean
  static bool? getBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  /// Simpan Double
  static Future<void> putDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  /// Ambil Double
  static double? getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  /// Simpan List<String>
  static Future<void> putStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  /// Ambil List<String>
  static List<String>? getStringList(String key, {List<String> defaultValue = const []}) {
    return _preferences?.getStringList(key) ?? defaultValue;
  }

  /// Hapus satu key
  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  /// Hapus semua data di SharedPreferences
  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
