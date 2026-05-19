import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class HiveHelper {
  static Future<void> openBoxes() async {
    await Hive.openBox(AppConstants.postsBox);
    await Hive.openBox(AppConstants.authBox);
  }

  static Box get _authBox => Hive.box(AppConstants.authBox);
  static Box get _postsBox => Hive.box(AppConstants.postsBox);

  // ─── Auth ──────────────────────────────────────────────────────────────────

  static Future<void> saveToken(String token) async =>
      _authBox.put(AppConstants.tokenKey, token);

  static String? getToken() =>
      _authBox.get(AppConstants.tokenKey) as String?;

  static Future<void> saveEmail(String email) async =>
      _authBox.put(AppConstants.userEmailKey, email);

  static String? getEmail() =>
      _authBox.get(AppConstants.userEmailKey) as String?;

  static Future<void> clearAuth() async {
    await _authBox.delete(AppConstants.tokenKey);
    await _authBox.delete(AppConstants.userEmailKey);
  }

  static bool get isLoggedIn => getToken() != null;

  // ─── Posts Cache ───────────────────────────────────────────────────────────

  static Future<void> saveCachedPosts(String encoded) async =>
      _postsBox.put(AppConstants.cachedPostsKey, encoded);

  static String? getCachedPostsRaw() =>
      _postsBox.get(AppConstants.cachedPostsKey) as String?;

  static Future<void> saveCachedPost(int id, String encoded) async =>
      _postsBox.put('post_$id', encoded);

  static String? getCachedPostRaw(int id) =>
      _postsBox.get('post_$id') as String?;

  // ─── Created Posts (Persisted) ─────────────────────────────────────────────
  // NEW: user-created posts survive app restarts

  static const _createdPostsKey = 'user_created_posts';

  /// Save a single newly created post to Hive.
  static Future<void> saveCreatedPost(Map<String, dynamic> post) async {
    final existing = getCreatedPosts();
    existing.add(post);
    await _postsBox.put(_createdPostsKey, jsonEncode(existing));
  }

  /// Load all user-created posts from Hive.
  static List<Map<String, dynamic>> getCreatedPosts() {
    try {
      final raw = _postsBox.get(_createdPostsKey) as String?;
      if (raw == null) return [];
      final List decoded = jsonDecode(raw) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Clear user-created posts (useful for testing / reset).
  static Future<void> clearCreatedPosts() async =>
      _postsBox.delete(_createdPostsKey);
}