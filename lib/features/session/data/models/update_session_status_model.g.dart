// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_session_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateSessionStatusModel _$UpdateSessionStatusModelFromJson(
  Map<String, dynamic> json,
) => _UpdateSessionStatusModel(
  sessionId: json['session_id'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$UpdateSessionStatusModelToJson(
  _UpdateSessionStatusModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'status': instance.status,
};
