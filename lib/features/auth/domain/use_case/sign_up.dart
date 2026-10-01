import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<AuthUser, SignUpParams> {
  final AuthRepository repository;

  const SignUp(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignUpParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
