import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock/mock_service.dart';
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
  final MockService mockService;

  PostsRemoteDatasourceImpl({
    required this.dio,
    required this.mockService,
  });

  @override
  Future<List<PostModel>> getPosts() async {
    if (AppConstants.useMockBackend) {
      final data = await mockService.getPosts();
      return data.map(PostModel.fromJson).toList();
    }

    try {
      final response = await dio.get('/posts?limit=30');
      // DummyJSON wraps in { "posts": [...] }; JSONPlaceholder returns plain list
      final raw = response.data;
      final List list =
          raw is Map ? raw['posts'] as List : raw as List;
      return list.map((j) => PostModel.fromJson(j)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<PostModel> getPost(int id) async {
    if (AppConstants.useMockBackend) {
      final data = await mockService.getPost(id);
      return PostModel.fromJson(data);
    }

    try {
      final response = await dio.get('/posts/$id');
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    if (AppConstants.useMockBackend) {
      final data = await mockService.createPost(
        title: title,
        body: body,
        userId: userId,
      );
      return PostModel.fromJson(data);
    }

    try {
      final response = await dio.post(
        '/posts/add',
        data: {'title': title, 'body': body, 'userId': userId},
      );
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }
}