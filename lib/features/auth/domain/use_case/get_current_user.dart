import 'package:dartz/dartz.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AuthUser?, NoParams> {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}