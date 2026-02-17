// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionModel {

@JsonKey(name: 'session_id') String? get sessionId;@JsonKey(name: 'family_id') String? get familyId;@JsonKey(name: 'chat_id') String? get chatId; String? get name; String? get location; String? get timestamp;@JsonKey(name: 'session_status') String? get sessionStatus;@JsonKey(name: 'shopper_user_id') String? get shopperUserId;@JsonKey(name: 'start_time') String? get startTime;@JsonKey(name: 'end_time') String? get endTime;
/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionModelCopyWith<SessionModel> get copyWith => _$SessionModelCopyWithImpl<SessionModel>(this as SessionModel, _$identity);

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus)&&(identical(other.shopperUserId, shopperUserId) || other.shopperUserId == shopperUserId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,chatId,name,location,timestamp,sessionStatus,shopperUserId,startTime,endTime);

@override
String toString() {
  return 'SessionModel(sessionId: $sessionId, familyId: $familyId, chatId: $chatId, name: $name, location: $location, timestamp: $timestamp, sessionStatus: $sessionStatus, shopperUserId: $shopperUserId, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $SessionModelCopyWith<$Res>  {
  factory $SessionModelCopyWith(SessionModel value, $Res Function(SessionModel) _then) = _$SessionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId,@JsonKey(name: 'family_id') String? familyId,@JsonKey(name: 'chat_id') String? chatId, String? name, String? location, String? timestamp,@JsonKey(name: 'session_status') String? sessionStatus,@JsonKey(name: 'shopper_user_id') String? shopperUserId,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime
});




}
/// @nodoc
class _$SessionModelCopyWithImpl<$Res>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._self, this._then);

  final SessionModel _self;
  final $Res Function(SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? familyId = freezed,Object? chatId = freezed,Object? name = freezed,Object? location = freezed,Object? timestamp = freezed,Object? sessionStatus = freezed,Object? shopperUserId = freezed,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,sessionStatus: freezed == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as String?,shopperUserId: freezed == shopperUserId ? _self.shopperUserId : shopperUserId // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionModel].
extension SessionModelPatterns on SessionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'chat_id')  String? chatId,  String? name,  String? location,  String? timestamp, @JsonKey(name: 'session_status')  String? sessionStatus, @JsonKey(name: 'shopper_user_id')  String? shopperUserId, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.chatId,_that.name,_that.location,_that.timestamp,_that.sessionStatus,_that.shopperUserId,_that.startTime,_that.endTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'chat_id')  String? chatId,  String? name,  String? location,  String? timestamp, @JsonKey(name: 'session_status')  String? sessionStatus, @JsonKey(name: 'shopper_user_id')  String? shopperUserId, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime)  $default,) {final _that = this;
switch (_that) {
case _SessionModel():
return $default(_that.sessionId,_that.familyId,_that.chatId,_that.name,_that.location,_that.timestamp,_that.sessionStatus,_that.shopperUserId,_that.startTime,_that.endTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'chat_id')  String? chatId,  String? name,  String? location,  String? timestamp, @JsonKey(name: 'session_status')  String? sessionStatus, @JsonKey(name: 'shopper_user_id')  String? shopperUserId, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime)?  $default,) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.chatId,_that.name,_that.location,_that.timestamp,_that.sessionStatus,_that.shopperUserId,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionModel implements SessionModel {
  const _SessionModel({@JsonKey(name: 'session_id') this.sessionId, @JsonKey(name: 'family_id') this.familyId, @JsonKey(name: 'chat_id') this.chatId, this.name, this.location, this.timestamp, @JsonKey(name: 'session_status') this.sessionStatus, @JsonKey(name: 'shopper_user_id') this.shopperUserId, @JsonKey(name: 'start_time') this.startTime, @JsonKey(name: 'end_time') this.endTime});
  factory _SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

@override@JsonKey(name: 'session_id') final  String? sessionId;
@override@JsonKey(name: 'family_id') final  String? familyId;
@override@JsonKey(name: 'chat_id') final  String? chatId;
@override final  String? name;
@override final  String? location;
@override final  String? timestamp;
@override@JsonKey(name: 'session_status') final  String? sessionStatus;
@override@JsonKey(name: 'shopper_user_id') final  String? shopperUserId;
@override@JsonKey(name: 'start_time') final  String? startTime;
@override@JsonKey(name: 'end_time') final  String? endTime;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionModelCopyWith<_SessionModel> get copyWith => __$SessionModelCopyWithImpl<_SessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus)&&(identical(other.shopperUserId, shopperUserId) || other.shopperUserId == shopperUserId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,chatId,name,location,timestamp,sessionStatus,shopperUserId,startTime,endTime);

@override
String toString() {
  return 'SessionModel(sessionId: $sessionId, familyId: $familyId, chatId: $chatId, name: $name, location: $location, timestamp: $timestamp, sessionStatus: $sessionStatus, shopperUserId: $shopperUserId, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$SessionModelCopyWith<$Res> implements $SessionModelCopyWith<$Res> {
  factory _$SessionModelCopyWith(_SessionModel value, $Res Function(_SessionModel) _then) = __$SessionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId,@JsonKey(name: 'family_id') String? familyId,@JsonKey(name: 'chat_id') String? chatId, String? name, String? location, String? timestamp,@JsonKey(name: 'session_status') String? sessionStatus,@JsonKey(name: 'shopper_user_id') String? shopperUserId,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime
});




}
/// @nodoc
class __$SessionModelCopyWithImpl<$Res>
    implements _$SessionModelCopyWith<$Res> {
  __$SessionModelCopyWithImpl(this._self, this._then);

  final _SessionModel _self;
  final $Res Function(_SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? familyId = freezed,Object? chatId = freezed,Object? name = freezed,Object? location = freezed,Object? timestamp = freezed,Object? sessionStatus = freezed,Object? shopperUserId = freezed,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(_SessionModel(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,sessionStatus: freezed == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as String?,shopperUserId: freezed == shopperUserId ? _self.shopperUserId : shopperUserId // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
