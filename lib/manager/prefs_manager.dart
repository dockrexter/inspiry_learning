// ignore_for_file: unused_element

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  SharedPreferencesManager._init();

  static SharedPreferencesManager get instance => _instance;

  static final SharedPreferencesManager _instance = SharedPreferencesManager._init();

  late SharedPreferences _preferences;

  Future<void> initPrefrences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  int? _getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      return null;
    }
  }

  void _setInt(String key, int value) {
    _preferences.setInt(key, value);
  }
}