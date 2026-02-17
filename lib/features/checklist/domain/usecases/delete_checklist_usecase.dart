import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/repositories/checklist_repository_impl.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class DeleteChecklistUsecase {
  final ChecklistRepository repository;
  DeleteChecklistUsecase(this.repository);
  Future<Either<Failure, void>> call(String checklistId) =>
      repository.deleteChecklist(checklistId);
}

final deleteChecklistUsecaseProvider = Provider<DeleteChecklistUsecase>((ref) {
  return DeleteChecklistUsecase(ref.watch(checklistRepositoryProvider));
});
