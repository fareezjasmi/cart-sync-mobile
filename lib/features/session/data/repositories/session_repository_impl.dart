import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/datasources/session_remote_datasource.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDatasource datasource;
  SessionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, SessionModel>> createSession(SessionModel session) async {
    try {
      return Right(await datasource.createSession(session));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to create session'));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> getSession(String sessionId) async {
    try {
      return Right(await datasource.getSession(sessionId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Session not found'));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> updateSessionStatus(
      String sessionId, String status) async {
    try {
      return Right(await datasource.updateSessionStatus(sessionId, status));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to update status'));
    }
  }
  
  @override
  Future<Either<Failure, List<SessionModel>>> getAllSession(String familyId) async {
    try {
      return Right(await datasource.getAllSession(familyId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to update status'));
    }
  }
}

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(ref.watch(sessionRemoteDatasourceProvider));
});
