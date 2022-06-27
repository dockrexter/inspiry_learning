import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferencesManager._init();

  static SharedPreferencesManager get instance => _instance;

  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._init();

  late SharedPreferences _preferences;

  Future<void> initPrefrences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? _getString(String key) {
    try {
      final val = _preferences.getString(key);
      if (val == null) return null;
      return val.isEmpty ? null : val;
    } catch (_) {
      return null;
    }
  }

  int? _getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (_) {
      return null;
    }
  }

  bool? _getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  Future<bool> _setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  Future<bool> _setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  Future<bool> saveToken(String token) async {
    return await _setString('token', token);
  }

  String? getToken() {
    return _getString('token');
  }

  Future<bool> saveUserId(int userId) async {
    return await _setInt('user_id', userId);
  }

  int? getUserId() {
    return _getInt('user_id');
  }

  Future<bool> setIsAdmin(bool isAdmin) async {
    return await _setBool('usertype', isAdmin);
  }

  bool? getIsAdmin() {
    return _getBool('usertype');
  }
}
