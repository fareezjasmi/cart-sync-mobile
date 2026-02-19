import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/datasources/checklist_remote_datasource.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDatasource datasource;
  ChecklistRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ChecklistModel>> createChecklist(ChecklistModel checklist) async {
    try {
      return Right(await datasource.createChecklist(checklist));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to create checklist'));
    }
  }

  @override
  Future<Either<Failure, ChecklistModel>> getChecklist(String checklistId) async {
    try {
      return Right(await datasource.getChecklist(checklistId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Checklist not found'));
    }
  }

  @override
  Future<Either<Failure, ChecklistModel>> updateChecklistName(String checklistId, String name) async {
    try {
      return Right(await datasource.updateChecklistName(checklistId, name));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to update checklist'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChecklist(String checklistId) async {
    try {
      await datasource.deleteChecklist(checklistId);
      return const Right(null);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to delete checklist'));
    }
  }

  @override
  Future<Either<Failure, List<ChecklistModel>>> getAllChecklist(String sessionId) async {
    try {
      return Right(await datasource.getAllChecklist(sessionId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Checklist not found'));
    }
  }
}

final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  return ChecklistRepositoryImpl(ref.watch(checklistRemoteDatasourceProvider));
});
