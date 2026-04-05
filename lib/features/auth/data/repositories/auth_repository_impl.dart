import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cartsync/features/auth/data/models/forgot_password_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_response_model.dart';
import 'package:cartsync/features/auth/data/models/reset_password_request_model.dart';
import 'package:cartsync/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, LoginResponseModel>> login(
      LoginRequestModel request) async {
    try {
      final result = await datasource.login(request);
      return Right(result);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> register(
      LoginRequestModel request) async {
    try {
      final result = await datasource.register(request);
      return Right(result);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Registration failed'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(
      ForgotPasswordRequestModel request) async {
    try {
      await datasource.forgotPassword(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      ResetPasswordRequestModel request) async {
    try {
      await datasource.resetPassword(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Password reset failed'));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));
});
