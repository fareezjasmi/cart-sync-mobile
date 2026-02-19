import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/data/repositories/checklist_repository_impl.dart';
import 'package:cartsync/features/checklist/domain/repositories/checklist_repository.dart';

class GetAllChecklistUsecase {
  final ChecklistRepository repository;
  GetAllChecklistUsecase(this.repository);
  Future<Either<Failure, List<ChecklistModel>>> call(String sessionId) => repository.getAllChecklist(sessionId);
}

final getAllChecklistUsecaseProvider = Provider<GetAllChecklistUsecase>((ref) {
  return GetAllChecklistUsecase(ref.watch(checklistRepositoryProvider));
});
