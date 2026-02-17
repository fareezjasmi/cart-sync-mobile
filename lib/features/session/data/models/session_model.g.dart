// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      sessionId: json['session_id'] as String?,
      familyId: json['family_id'] as String?,
      chatId: json['chat_id'] as String?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      timestamp: json['timestamp'] as String?,
      sessionStatus: json['session_status'] as String?,
      shopperUserId: json['shopper_user_id'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'family_id': instance.familyId,
      'chat_id': instance.chatId,
      'name': instance.name,
      'location': instance.location,
      'timestamp': instance.timestamp,
      'session_status': instance.sessionStatus,
      'shopper_user_id': instance.shopperUserId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
