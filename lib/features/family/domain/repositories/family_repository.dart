import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';

abstract class FamilyRepository {
  Future<Either<Failure, FamilyModel>> createFamily(FamilyModel family);
  Future<Either<Failure, FamilyModel>> getFamily(String familyId);
  Future<Either<Failure, FamilyRelationshipModel>> addMember(String familyId, String userId);
  Future<Either<Failure, List<FamilyRelationshipModel>>> getFamilyMembers(String familyId);
}
