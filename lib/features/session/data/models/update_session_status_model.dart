import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_session_status_model.freezed.dart';
part 'update_session_status_model.g.dart';

@freezed
abstract class UpdateSessionStatusModel with _$UpdateSessionStatusModel {
  const factory UpdateSessionStatusModel({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'status') required String status,
  }) = _UpdateSessionStatusModel;

  factory UpdateSessionStatusModel.fromJson(Map<String, Object?> json) =>
      _$UpdateSessionStatusModelFromJson(json);
}
