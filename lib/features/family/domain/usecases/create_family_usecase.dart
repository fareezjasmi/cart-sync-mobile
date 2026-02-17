import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class CreateFamilyUsecase {
  final FamilyRepository repository;
  CreateFamilyUsecase(this.repository);
  Future<Either<Failure, FamilyModel>> call(FamilyModel family) =>
      repository.createFamily(family);
}

final createFamilyUsecaseProvider = Provider<CreateFamilyUsecase>((ref) {
  return CreateFamilyUsecase(ref.watch(familyRepositoryProvider));
});
