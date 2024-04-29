import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences? _prefs;

  static const baseUrl = "baseUrl";

  static init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static putInteger(String key, int value) {
    _prefs?.setInt(key, value);
  }

  static int getInteger(String key) {
    return _prefs == null ? 0 : _prefs?.getInt(key) ?? 0;
  }

  static putString(String key, String value) {
    _prefs?.setString(key, value);
  }

  static String getString(String key) {
    return _prefs == null ? '' : _prefs?.getString(key) ?? "";
  }

  static putBool(String key, bool value) {
    _prefs?.setBool(key, value);
  }

  static bool getBool(String key) {
    return _prefs == null ? false : _prefs?.getBool(key) ?? false;
  }
}
