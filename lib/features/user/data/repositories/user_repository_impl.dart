import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/user/data/datasources/user_remote_datasource.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';
import 'package:cartsync/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource datasource;
  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final result = await datasource.getCurrentUser();
      return Right(result);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to get user'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> upsertUser(UserModel user) async {
    try {
      final result = await datasource.upsertUser(user);
      return Right(result);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to update user'));
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDatasourceProvider));
});
