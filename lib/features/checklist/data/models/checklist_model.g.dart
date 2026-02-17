// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) =>
    _ChecklistModel(
      checklistId: json['checklist_id'] as String?,
      sessionId: json['session_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$ChecklistModelToJson(_ChecklistModel instance) =>
    <String, dynamic>{
      'checklist_id': instance.checklistId,
      'session_id': instance.sessionId,
      'name': instance.name,
      'image': instance.image,
      'timestamp': instance.timestamp,
    };
