// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_checklist_name_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateChecklistNameModel _$UpdateChecklistNameModelFromJson(
  Map<String, dynamic> json,
) => _UpdateChecklistNameModel(
  checklistId: json['checklist_id'] as String,
  checklistName: json['checklist_name'] as String,
);

Map<String, dynamic> _$UpdateChecklistNameModelToJson(
  _UpdateChecklistNameModel instance,
) => <String, dynamic>{
  'checklist_id': instance.checklistId,
  'checklist_name': instance.checklistName,
};
