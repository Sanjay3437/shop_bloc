import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String name;
  final String email;

  const AuthUser({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}