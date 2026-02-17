import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class GetFamilyMembersUsecase {
  final FamilyRepository repository;
  GetFamilyMembersUsecase(this.repository);
  Future<Either<Failure, List<FamilyRelationshipModel>>> call(String familyId) =>
      repository.getFamilyMembers(familyId);
}

final getFamilyMembersUsecaseProvider =
    Provider<GetFamilyMembersUsecase>((ref) {
  return GetFamilyMembersUsecase(ref.watch(familyRepositoryProvider));
});
