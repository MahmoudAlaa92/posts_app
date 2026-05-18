import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDatasource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPost(int id);
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  });
}

class PostsRemoteDatasourceImpl implements PostsRemoteDatasource {
  final Dio dio;

  PostsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dio.get('/posts');
      final List data = response.data as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> getPost(int id) async {
    try {
      final response = await dio.get('/posts/$id');
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await dio.post(
        '/posts',
        data: {'title': title, 'body': body, 'userId': userId},
      );
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}