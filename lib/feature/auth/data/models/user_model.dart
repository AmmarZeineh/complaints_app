import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String accessToken;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      accessToken: json['accessToken'],
    );
  }

  factory UserModel.toJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      accessToken: json['accessToken'],
    );
  }
  UserEntity toEntity() =>
      UserEntity(id: id, name: name, email: email, accessToken: accessToken);
}
