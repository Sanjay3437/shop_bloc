import 'package:dartz/dartz.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class SignOut implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  const SignOut(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.signOut();
  }
}
