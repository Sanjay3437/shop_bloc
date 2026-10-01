import 'package:dartz/dartz.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  /// The logged-in user, or null if nobody is logged in.
  Future<Either<Failure, AuthUser?>> getCurrentUser();
}