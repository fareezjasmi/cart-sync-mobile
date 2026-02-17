import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class AddFamilyMemberUsecase {
  final FamilyRepository repository;
  AddFamilyMemberUsecase(this.repository);
  Future<Either<Failure, FamilyRelationshipModel>> call(
          String familyId, String userId) =>
      repository.addMember(familyId, userId);
}

final addFamilyMemberUsecaseProvider = Provider<AddFamilyMemberUsecase>((ref) {
  return AddFamilyMemberUsecase(ref.watch(familyRepositoryProvider));
});
