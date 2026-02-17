import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, ChecklistModel>> createChecklist(ChecklistModel checklist);
  Future<Either<Failure, ChecklistModel>> getChecklist(String checklistId);
  Future<Either<Failure, ChecklistModel>> updateChecklistName(String checklistId, String name);
  Future<Either<Failure, void>> deleteChecklist(String checklistId);
}
