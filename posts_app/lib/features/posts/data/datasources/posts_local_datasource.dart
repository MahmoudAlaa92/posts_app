import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/hive_helper.dart';
import '../models/post_model.dart';

abstract class PostsLocalDatasource {
  Future<void> cachePosts(List<PostModel> posts);
  List<PostModel> getCachedPosts();
  Future<void> cachePost(PostModel post);
  PostModel? getCachedPost(int id);
}

class PostsLocalDatasourceImpl implements PostsLocalDatasource {
  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final encoded = jsonEncode(posts.map((p) => p.toJson()).toList());
      await HiveHelper.postsBox.put(AppConstants.cachedPostsKey, encoded);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache posts');
    }
  }

  @override
  List<PostModel> getCachedPosts() {
    try {
      final encoded =
          HiveHelper.postsBox.get(AppConstants.cachedPostsKey) as String?;
      if (encoded == null) return [];

      final List decoded = jsonDecode(encoded) as List;
      return decoded.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cachePost(PostModel post) async {
    try {
      await HiveHelper.postsBox.put('post_${post.id}', jsonEncode(post.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to cache post ${post.id}');
    }
  }

  @override
  PostModel? getCachedPost(int id) {
    try {
      final encoded = HiveHelper.postsBox.get('post_$id') as String?;
      if (encoded == null) return null;
      return PostModel.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}