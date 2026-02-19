

import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetAllFamilyUsecase {
  final FamilyRepository repository;
  GetAllFamilyUsecase(this.repository);
  Future<Either<Failure, List<FamilyModel>>> call(String userId) =>
      repository.getAllFamily(userId);
}

final GetAllFamilyUsecaseProvider =
    Provider<GetAllFamilyUsecase>((ref) {
  return GetAllFamilyUsecase(ref.watch(familyRepositoryProvider));
});
