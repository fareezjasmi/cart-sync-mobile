import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_model.freezed.dart';
part 'checklist_model.g.dart';

@freezed
abstract class ChecklistModel with _$ChecklistModel {
  const factory ChecklistModel({
    @JsonKey(name: 'checklist_id') String? checklistId,
    @JsonKey(name: 'session_id') String? sessionId,
    String? name,
    String? image,
    String? timestamp,
  }) = _ChecklistModel;

  factory ChecklistModel.fromJson(Map<String, Object?> json) =>
      _$ChecklistModelFromJson(json);
}
