import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
abstract class ItemModel with _$ItemModel {
  const factory ItemModel({
    @JsonKey(name: 'item_id') String? itemId,
    @JsonKey(name: 'checklist_id') String? checklistId,
    String? name,
    String? image,
    @JsonKey(name: 'isBought') bool? isBought,
    String? timestamp,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, Object?> json) =>
      _$ItemModelFromJson(json);
}
