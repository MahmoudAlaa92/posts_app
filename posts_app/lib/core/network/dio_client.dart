import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio getInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor (only in debug)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        error: true,
        requestHeader: false,
      ),
    );

    // Auth interceptor — attach token if available
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Token injection can be added here when needed
          handler.next(options);
        },
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    );

    return dio;
  }
}