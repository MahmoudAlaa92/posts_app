import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/hive_helper.dart';
import '../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await HiveHelper.saveToken(user.token);
      await HiveHelper.saveEmail(user.email);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache user');
    }
  }

  @override
  UserModel? getCachedUser() {
    final token = HiveHelper.getToken();
    final email = HiveHelper.getEmail();

    if (token == null || email == null) return null;

    return UserModel(email: email, token: token);
  }

  @override
  Future<void> clearCache() async {
    await HiveHelper.clearAuth();
  }
}