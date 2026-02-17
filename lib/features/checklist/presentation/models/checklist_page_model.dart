import 'package:cartsync/features/checklist/data/models/checklist_model.dart';

class ChecklistPageModel {
  final bool isLoading;
  final ChecklistModel? currentChecklist;
  final List<ChecklistModel> checklists;
  final String? errorMessage;

  ChecklistPageModel({
    this.isLoading = false,
    this.currentChecklist,
    this.checklists = const [],
    this.errorMessage,
  });

  ChecklistPageModel copyWith({
    bool? isLoading,
    ChecklistModel? currentChecklist,
    List<ChecklistModel>? checklists,
    String? errorMessage,
  }) {
    return ChecklistPageModel(
      isLoading: isLoading ?? this.isLoading,
      currentChecklist: currentChecklist ?? this.currentChecklist,
      checklists: checklists ?? this.checklists,
      errorMessage: errorMessage,
    );
  }
}

class ChecklistPageInitial extends ChecklistPageModel {
  ChecklistPageInitial() : super();
}
