import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock/mock_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;
  final MockService mockService;

  AuthRemoteDatasourceImpl({
    required this.dio,
    required this.mockService,
  });

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    if (AppConstants.useMockBackend) {
      // ─── MOCK ────────────────────────────────────────────
      final data = await mockService.login(
        username: username,
        password: password,
      );
      return UserModel.fromJson(data);
    }

    // ─── REAL API ────────────────────────────────────────
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        throw const AuthException(message: 'Invalid username or password');
      }
      throw ServerException(message: e.message ?? 'Network error');
    }
  }
}