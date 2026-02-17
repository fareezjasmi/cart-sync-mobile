import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/datasources/family_remote_datasource.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyRemoteDatasource datasource;
  FamilyRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, FamilyModel>> createFamily(FamilyModel family) async {
    try {
      return Right(await datasource.createFamily(family));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to create family'));
    }
  }

  @override
  Future<Either<Failure, FamilyModel>> getFamily(String familyId) async {
    try {
      return Right(await datasource.getFamily(familyId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to get family'));
    }
  }

  @override
  Future<Either<Failure, FamilyRelationshipModel>> addMember(
      String familyId, String userId) async {
    try {
      return Right(await datasource.addMember(familyId, userId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to add member'));
    }
  }

  @override
  Future<Either<Failure, List<FamilyRelationshipModel>>> getFamilyMembers(
      String familyId) async {
    try {
      return Right(await datasource.getFamilyMembers(familyId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to get members'));
    }
  }
}

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepositoryImpl(ref.watch(familyRemoteDatasourceProvider));
});
