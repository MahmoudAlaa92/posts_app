import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class HiveHelper {
  static Future<void> openBoxes() async {
    await Hive.openBox(AppConstants.postsBox);
    await Hive.openBox(AppConstants.authBox);
  }

  // Auth box helpers
  static Box get authBox => Hive.box(AppConstants.authBox);
  static Box get postsBox => Hive.box(AppConstants.postsBox);

  static Future<void> saveToken(String token) async {
    await authBox.put(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return authBox.get(AppConstants.tokenKey) as String?;
  }

  static Future<void> saveEmail(String email) async {
    await authBox.put(AppConstants.userEmailKey, email);
  }

  static String? getEmail() {
    return authBox.get(AppConstants.userEmailKey) as String?;
  }

  static Future<void> clearAuth() async {
    await authBox.delete(AppConstants.tokenKey);
    await authBox.delete(AppConstants.userEmailKey);
  }

  static bool get isLoggedIn => getToken() != null;
}