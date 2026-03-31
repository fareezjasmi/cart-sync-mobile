import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class DeleteFamilyUsecase {
  final FamilyRepository repository;
  DeleteFamilyUsecase(this.repository);
  Future<Either<Failure, Map<String, dynamic>>> call(String familyId) =>
      repository.deleteFamily(familyId);
}

final deleteFamilyUsecaseProvider = Provider<DeleteFamilyUsecase>((ref) {
  return DeleteFamilyUsecase(ref.watch(familyRepositoryProvider));
});
