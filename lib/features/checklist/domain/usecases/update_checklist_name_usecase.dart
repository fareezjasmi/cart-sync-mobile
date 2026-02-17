import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/data/repositories/checklist_repository_impl.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class UpdateChecklistNameUsecase {
  final ChecklistRepository repository;
  UpdateChecklistNameUsecase(this.repository);
  Future<Either<Failure, ChecklistModel>> call(String checklistId, String name) =>
      repository.updateChecklistName(checklistId, name);
}

final updateChecklistNameUsecaseProvider =
    Provider<UpdateChecklistNameUsecase>((ref) {
  return UpdateChecklistNameUsecase(ref.watch(checklistRepositoryProvider));
});
