import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class JoinFamilyUsecase {
  final FamilyRepository repository;
  JoinFamilyUsecase(this.repository);
  Future<Either<Failure, FamilyRelationshipModel>> call(String inviteCode, String userId) =>
      repository.joinFamily(inviteCode, userId);
}

final joinFamilyUsecaseProvider = Provider<JoinFamilyUsecase>((ref) {
  return JoinFamilyUsecase(ref.watch(familyRepositoryProvider));
});
