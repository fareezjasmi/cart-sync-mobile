import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/repositories/family_repository_impl.dart';
import 'package:cartsync/features/family/domain/repositories/family_repository.dart';

class GenerateInviteCodeUsecase {
  final FamilyRepository repository;
  GenerateInviteCodeUsecase(this.repository);
  Future<Either<Failure, FamilyModel>> call(String familyId) =>
      repository.generateInviteCode(familyId);
}

final generateInviteCodeUsecaseProvider = Provider<GenerateInviteCodeUsecase>((ref) {
  return GenerateInviteCodeUsecase(ref.watch(familyRepositoryProvider));
});
