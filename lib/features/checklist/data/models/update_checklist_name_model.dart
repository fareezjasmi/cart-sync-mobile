import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_checklist_name_model.freezed.dart';
part 'update_checklist_name_model.g.dart';

@freezed
abstract class UpdateChecklistNameModel with _$UpdateChecklistNameModel {
  const factory UpdateChecklistNameModel({
    @JsonKey(name: 'checklist_id') required String checklistId,
    @JsonKey(name: 'checklist_name') required String checklistName,
  }) = _UpdateChecklistNameModel;

  factory UpdateChecklistNameModel.fromJson(Map<String, Object?> json) =>
      _$UpdateChecklistNameModelFromJson(json);
}
