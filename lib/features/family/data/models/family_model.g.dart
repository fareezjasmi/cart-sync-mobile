// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyModel _$FamilyModelFromJson(Map<String, dynamic> json) => _FamilyModel(
  familyId: json['family_id'] as String?,
  adminId: json['admin_id'] as String?,
  name: json['name'] as String?,
  inviteCode: json['invite_code'] as String?,
  inviteCodeExpiry: json['invite_code_expiry'] as String?,
  dateCreated: json['date_created'] as String?,
  lastUpdated: json['last_updated'] as String?,
  isAdmin: json['isAdmin'] as bool?,
);

Map<String, dynamic> _$FamilyModelToJson(_FamilyModel instance) =>
    <String, dynamic>{
      'family_id': instance.familyId,
      'admin_id': instance.adminId,
      'name': instance.name,
      'invite_code': instance.inviteCode,
      'invite_code_expiry': instance.inviteCodeExpiry,
      'date_created': instance.dateCreated,
      'last_updated': instance.lastUpdated,
      'isAdmin': instance.isAdmin,
    };
