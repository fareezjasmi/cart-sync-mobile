// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => _ItemModel(
  itemId: json['item_id'] as String?,
  checklistId: json['checklist_id'] as String?,
  name: json['name'] as String?,
  image: json['image'] as String?,
  isBought: json['isBought'] as bool?,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$ItemModelToJson(_ItemModel instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'checklist_id': instance.checklistId,
      'name': instance.name,
      'image': instance.image,
      'isBought': instance.isBought,
      'timestamp': instance.timestamp,
    };
