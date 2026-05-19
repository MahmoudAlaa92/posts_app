import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/hive_helper.dart';
import '../models/post_model.dart';

abstract class PostsLocalDatasource {
  Future<void> cachePosts(List<PostModel> posts);
  List<PostModel> getCachedPosts();
  Future<void> cachePost(PostModel post);
  PostModel? getCachedPost(int id);

  // persist user-created posts
  Future<void> saveCreatedPost(PostModel post);
  List<PostModel> getCreatedPosts();
}

class PostsLocalDatasourceImpl implements PostsLocalDatasource {
  // ─── Fetched posts cache (offline support) ──────────────────────────────

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final encoded = jsonEncode(posts.map((p) => p.toJson()).toList());
      await HiveHelper.saveCachedPosts(encoded);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache posts');
    }
  }

  @override
  List<PostModel> getCachedPosts() {
    try {
      final raw = HiveHelper.getCachedPostsRaw();
      if (raw == null) return [];
      final List decoded = jsonDecode(raw) as List;
      return decoded
          .map((j) => PostModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cachePost(PostModel post) async {
    try {
      await HiveHelper.saveCachedPost(post.id, jsonEncode(post.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to cache post ${post.id}');
    }
  }

  @override
  PostModel? getCachedPost(int id) {
    try {
      final raw = HiveHelper.getCachedPostRaw(id);
      if (raw == null) return null;
      return PostModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ─── User-created posts (persisted across restarts) ─────────────────────

  @override
  Future<void> saveCreatedPost(PostModel post) async {
    try {
      await HiveHelper.saveCreatedPost(post.toJson());
    } catch (e) {
      throw const CacheException(message: 'Failed to save created post');
    }
  }

  @override
  List<PostModel> getCreatedPosts() {
    return HiveHelper.getCreatedPosts()
        .map((j) => PostModel.fromJson(j))
        .toList();
  }
}