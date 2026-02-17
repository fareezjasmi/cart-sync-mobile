import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_relationship_model.freezed.dart';
part 'family_relationship_model.g.dart';

@freezed
abstract class FamilyRelationshipModel with _$FamilyRelationshipModel {
  const factory FamilyRelationshipModel({
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'family_id') String? familyId,
  }) = _FamilyRelationshipModel;

  factory FamilyRelationshipModel.fromJson(Map<String, Object?> json) =>
      _$FamilyRelationshipModelFromJson(json);
}
