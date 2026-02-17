import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_model.freezed.dart';
part 'family_model.g.dart';

@freezed
abstract class FamilyModel with _$FamilyModel {
  const factory FamilyModel({
    @JsonKey(name: 'family_id') String? familyId,
    @JsonKey(name: 'admin_id') String? adminId,
    String? name,
    @JsonKey(name: 'date_created') String? dateCreated,
    @JsonKey(name: 'last_updated') String? lastUpdated,
  }) = _FamilyModel;

  factory FamilyModel.fromJson(Map<String, Object?> json) =>
      _$FamilyModelFromJson(json);
}
