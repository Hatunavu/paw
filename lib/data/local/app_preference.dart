import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String KEY_FIRST_INSTALL = 'install';
  static const String KEY_FIRST_LOGIN = 'login';
  static const String KEY_LANGUAGE = 'language';

  static Future<bool> setFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(KEY_FIRST_INSTALL, false);
  }

  static Future<bool> isFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool(KEY_FIRST_INSTALL);
    return result == null;
  }

  static Future setLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_LANGUAGE, language);
  }

  static Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_LANGUAGE);
  }

  static Future<bool> setFirstLogin(bool isFirstLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(KEY_FIRST_LOGIN, isFirstLogin);
  }

  static Future<bool> isFirstLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool(KEY_FIRST_LOGIN);
    return prefs.getBool(KEY_FIRST_LOGIN);
  }

  static Future<void> deleleFirstLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_FIRST_LOGIN);
  }
}
