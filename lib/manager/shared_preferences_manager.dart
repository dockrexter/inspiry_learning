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

  Future<bool> _setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  Future<bool> _remove(String key) async {
    return await _preferences.remove(key);
  }

  Future<bool> saveUser(String user) async {
    return await _setString('user', user);
  }

  Future<bool> removeUser() async {
    return await _remove('user');
  }

  String? getUser() {
    return _getString('user');
  }

  Future<bool> setIsAdmin(bool isAdmin) async {
    return await _setBool('usertype', isAdmin);
  }

  bool? getIsAdmin() {
    return _getBool('usertype');
  }
}
