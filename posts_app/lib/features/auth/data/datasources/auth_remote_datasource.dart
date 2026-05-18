import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Mock login — accepts hardcoded credentials
    // In production, replace with: await dio.post('/auth/login', data: {...})
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate latency

    if (email == AppConstants.mockEmail &&
        password == AppConstants.mockPassword) {
      return UserModel(
        email: email,
        token: AppConstants.mockToken,
      );
    }

    throw const AuthException(message: 'Invalid email or password');
  }
}