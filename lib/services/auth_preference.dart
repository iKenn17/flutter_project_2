import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';

  // Save login state
  static Future<void> setLoggedIn(bool value, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
    if (userId != null) {
      await prefs.setString(_keyUserId, userId);
    }
  }

  // Get login state
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get stored user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Clear on logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or use remove() for specific keys
  }
}
