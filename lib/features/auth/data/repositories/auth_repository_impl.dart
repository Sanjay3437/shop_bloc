import 'package:dartz/dartz.dart';
import 'package:shop_bloc/core/exceptions/app_exceptions.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return Right(
        await localDataSource.signIn(email: email, password: password),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception {
      return const Left(CacheFailure('Could not read local storage'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return Right(
        await localDataSource.signUp(
          name: name,
          email: email,
          password: password,
        ),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception {
      return const Left(CacheFailure('Could not save to local storage'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await localDataSource.signOut();
      return const Right(unit);
    } on Exception {
      return const Left(CacheFailure('Could not clear the session'));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      return Right(await localDataSource.getCurrentUser());
    } on Exception {
      return const Left(CacheFailure('Could not read the session'));
    }
  }
}