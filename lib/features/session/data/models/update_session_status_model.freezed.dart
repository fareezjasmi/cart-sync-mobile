// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_session_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateSessionStatusModel {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'status') String get status;
/// Create a copy of UpdateSessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSessionStatusModelCopyWith<UpdateSessionStatusModel> get copyWith => _$UpdateSessionStatusModelCopyWithImpl<UpdateSessionStatusModel>(this as UpdateSessionStatusModel, _$identity);

  /// Serializes this UpdateSessionStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSessionStatusModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status);

@override
String toString() {
  return 'UpdateSessionStatusModel(sessionId: $sessionId, status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateSessionStatusModelCopyWith<$Res>  {
  factory $UpdateSessionStatusModelCopyWith(UpdateSessionStatusModel value, $Res Function(UpdateSessionStatusModel) _then) = _$UpdateSessionStatusModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class _$UpdateSessionStatusModelCopyWithImpl<$Res>
    implements $UpdateSessionStatusModelCopyWith<$Res> {
  _$UpdateSessionStatusModelCopyWithImpl(this._self, this._then);

  final UpdateSessionStatusModel _self;
  final $Res Function(UpdateSessionStatusModel) _then;

/// Create a copy of UpdateSessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? status = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSessionStatusModel].
extension UpdateSessionStatusModelPatterns on UpdateSessionStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSessionStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSessionStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSessionStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSessionStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'status')  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSessionStatusModel() when $default != null:
return $default(_that.sessionId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'status')  String status)  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionStatusModel():
return $default(_that.sessionId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'status')  String status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionStatusModel() when $default != null:
return $default(_that.sessionId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateSessionStatusModel implements UpdateSessionStatusModel {
  const _UpdateSessionStatusModel({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'status') required this.status});
  factory _UpdateSessionStatusModel.fromJson(Map<String, dynamic> json) => _$UpdateSessionStatusModelFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'status') final  String status;

/// Create a copy of UpdateSessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSessionStatusModelCopyWith<_UpdateSessionStatusModel> get copyWith => __$UpdateSessionStatusModelCopyWithImpl<_UpdateSessionStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSessionStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSessionStatusModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status);

@override
String toString() {
  return 'UpdateSessionStatusModel(sessionId: $sessionId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateSessionStatusModelCopyWith<$Res> implements $UpdateSessionStatusModelCopyWith<$Res> {
  factory _$UpdateSessionStatusModelCopyWith(_UpdateSessionStatusModel value, $Res Function(_UpdateSessionStatusModel) _then) = __$UpdateSessionStatusModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class __$UpdateSessionStatusModelCopyWithImpl<$Res>
    implements _$UpdateSessionStatusModelCopyWith<$Res> {
  __$UpdateSessionStatusModelCopyWithImpl(this._self, this._then);

  final _UpdateSessionStatusModel _self;
  final $Res Function(_UpdateSessionStatusModel) _then;

/// Create a copy of UpdateSessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? status = null,}) {
  return _then(_UpdateSessionStatusModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
