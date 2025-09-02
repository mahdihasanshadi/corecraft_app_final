import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initPrefs();
  }

  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _prefs.setBool('_initialized', true);
    } catch (e) {
      print('Failed to initialize SharedPreferences: $e');
    }
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    if (!_prefs.containsKey('_initialized')) {
      await _initPrefs();
    }
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    if (!_prefs.containsKey('_initialized')) {
      return null;
    }
    return _prefs.getString(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // Auth token operations
  Future<bool> setToken(String token) async {
    return await setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return getString(AppConstants.tokenKey);
  }

  Future<bool> removeToken() async {
    return await remove(AppConstants.tokenKey);
  }

  // User data operations
  Future<bool> setUserData(String userData) async {
    return await setString(AppConstants.userKey, userData);
  }

  String? getUserData() {
    return getString(AppConstants.userKey);
  }

  Future<bool> removeUserData() async {
    return await remove(AppConstants.userKey);
  }

  // Theme operations
  Future<bool> setThemeMode(bool isDark) async {
    return await setBool(AppConstants.themeKey, isDark);
  }

  bool? getThemeMode() {
    return getBool(AppConstants.themeKey);
  }

  // Language operations
  Future<bool> setLanguage(String languageCode) async {
    return await setString(AppConstants.languageKey, languageCode);
  }

  String? getLanguage() {
    return getString(AppConstants.languageKey);
  }

  // Check if user is logged in
  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
