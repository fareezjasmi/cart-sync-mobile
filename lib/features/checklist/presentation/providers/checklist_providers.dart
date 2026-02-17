import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/domain/usecases/create_checklist_usecase.dart';
import 'package:cartsync/features/checklist/domain/usecases/delete_checklist_usecase.dart';
import 'package:cartsync/features/checklist/domain/usecases/get_checklist_usecase.dart';
import 'package:cartsync/features/checklist/domain/usecases/update_checklist_name_usecase.dart';
import 'package:cartsync/features/checklist/presentation/models/checklist_page_model.dart';

class ChecklistNotifier extends StateNotifier<ChecklistPageModel> {
  final Ref ref;
  final CreateChecklistUsecase createChecklistUsecase;
  final GetChecklistUsecase getChecklistUsecase;
  final UpdateChecklistNameUsecase updateChecklistNameUsecase;
  final DeleteChecklistUsecase deleteChecklistUsecase;

  ChecklistNotifier(
    this.ref,
    this.createChecklistUsecase,
    this.getChecklistUsecase,
    this.updateChecklistNameUsecase,
    this.deleteChecklistUsecase,
  ) : super(ChecklistPageInitial());

  Future<bool> createChecklist(String sessionId, String name) async {
    state = state.copyWith(isLoading: true);
    final checklist = ChecklistModel(sessionId: sessionId, name: name);
    final result = await createChecklistUsecase(checklist);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (c) {
        final updated = List<ChecklistModel>.from(state.checklists)..add(c);
        state = state.copyWith(isLoading: false, checklists: updated, currentChecklist: c);
        return true;
      },
    );
  }

  Future<void> loadChecklist(String checklistId) async {
    state = state.copyWith(isLoading: true);
    final result = await getChecklistUsecase(checklistId);
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (c) => state = state.copyWith(isLoading: false, currentChecklist: c),
    );
  }

  // Since the backend has no "get checklists by session" endpoint,
  // we track checklists locally after creation.
  void loadChecklistsBySession(String sessionId) {
    // Checklists are populated when created during this session
    state = state.copyWith(checklists: state.checklists
        .where((c) => c.sessionId == sessionId)
        .toList());
  }

  Future<bool> updateName(String checklistId, String name) async {
    state = state.copyWith(isLoading: true);
    final result = await updateChecklistNameUsecase(checklistId, name);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (c) {
        final updated = state.checklists
            .map((x) => x.checklistId == checklistId ? c : x)
            .toList();
        state = state.copyWith(isLoading: false, checklists: updated, currentChecklist: c);
        return true;
      },
    );
  }

  Future<bool> delete(String checklistId) async {
    state = state.copyWith(isLoading: true);
    final result = await deleteChecklistUsecase(checklistId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        final updated = state.checklists
            .where((c) => c.checklistId != checklistId)
            .toList();
        state = state.copyWith(isLoading: false, checklists: updated);
        return true;
      },
    );
  }
}

final checklistNotifierProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistPageModel>((ref) {
  return ChecklistNotifier(
    ref,
    ref.watch(createChecklistUsecaseProvider),
    ref.watch(getChecklistUsecaseProvider),
    ref.watch(updateChecklistNameUsecaseProvider),
    ref.watch(deleteChecklistUsecaseProvider),
  );
});
