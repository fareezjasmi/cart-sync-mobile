import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/data/repositories/checklist_repository_impl.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class GetChecklistUsecase {
  final ChecklistRepository repository;
  GetChecklistUsecase(this.repository);
  Future<Either<Failure, ChecklistModel>> call(String checklistId) =>
      repository.getChecklist(checklistId);
}

final getChecklistUsecaseProvider = Provider<GetChecklistUsecase>((ref) {
  return GetChecklistUsecase(ref.watch(checklistRepositoryProvider));
});
