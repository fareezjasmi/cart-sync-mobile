import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/data/repositories/checklist_repository_impl.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class CreateChecklistUsecase {
  final ChecklistRepository repository;
  CreateChecklistUsecase(this.repository);
  Future<Either<Failure, ChecklistModel>> call(ChecklistModel checklist) =>
      repository.createChecklist(checklist);
}

final createChecklistUsecaseProvider = Provider<CreateChecklistUsecase>((ref) {
  return CreateChecklistUsecase(ref.watch(checklistRepositoryProvider));
});
