import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _kToken = "token";
  static const _kRole = "role";
  static const _kName = "name";
  static const _kUserId = "userId";

  static Future<void> save({
    required String token,
    required String role,
    String? name,
    String? userId,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, token);
    await sp.setString(_kRole, role);
    if (name != null) await sp.setString(_kName, name);
    if (userId != null) await sp.setString(_kUserId, userId);
  }

  static Future<String?> token() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kToken);
  }

  static Future<String?> role() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kRole);
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
