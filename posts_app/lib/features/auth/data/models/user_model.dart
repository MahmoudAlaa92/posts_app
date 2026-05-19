import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.email, required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: (json['username'] ?? json['email'] ?? 'user') as String,
        token: (json['token'] ?? json['accessToken'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {'email': email, 'token': token};
}