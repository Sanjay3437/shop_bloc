import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({required super.name, required super.email});

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}