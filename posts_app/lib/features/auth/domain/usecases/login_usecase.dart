import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String username;
  final String password;
  const LoginParams({required this.username, required this.password});
}

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) =>
      repository.login(username: params.username, password: params.password);
}