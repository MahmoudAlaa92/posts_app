import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'] as String,
        token: json['token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
      };

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        email: entity.email,
        token: entity.token,
      );
}