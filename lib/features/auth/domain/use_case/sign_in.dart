import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignIn implements UseCase<AuthUser, SignInParams> {
  final AuthRepository repository;

  const SignIn(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignInParams params) {
    return repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}