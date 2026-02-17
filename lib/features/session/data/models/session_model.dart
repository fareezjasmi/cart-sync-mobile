import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    @JsonKey(name: 'session_id') String? sessionId,
    @JsonKey(name: 'family_id') String? familyId,
    @JsonKey(name: 'chat_id') String? chatId,
    String? name,
    String? location,
    String? timestamp,
    @JsonKey(name: 'session_status') String? sessionStatus,
    @JsonKey(name: 'shopper_user_id') String? shopperUserId,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, Object?> json) =>
      _$SessionModelFromJson(json);
}
