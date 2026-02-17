// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_checklist_name_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateChecklistNameModel {

@JsonKey(name: 'checklist_id') String get checklistId;@JsonKey(name: 'checklist_name') String get checklistName;
/// Create a copy of UpdateChecklistNameModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChecklistNameModelCopyWith<UpdateChecklistNameModel> get copyWith => _$UpdateChecklistNameModelCopyWithImpl<UpdateChecklistNameModel>(this as UpdateChecklistNameModel, _$identity);

  /// Serializes this UpdateChecklistNameModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChecklistNameModel&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.checklistName, checklistName) || other.checklistName == checklistName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checklistId,checklistName);

@override
String toString() {
  return 'UpdateChecklistNameModel(checklistId: $checklistId, checklistName: $checklistName)';
}


}

/// @nodoc
abstract mixin class $UpdateChecklistNameModelCopyWith<$Res>  {
  factory $UpdateChecklistNameModelCopyWith(UpdateChecklistNameModel value, $Res Function(UpdateChecklistNameModel) _then) = _$UpdateChecklistNameModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'checklist_id') String checklistId,@JsonKey(name: 'checklist_name') String checklistName
});




}
/// @nodoc
class _$UpdateChecklistNameModelCopyWithImpl<$Res>
    implements $UpdateChecklistNameModelCopyWith<$Res> {
  _$UpdateChecklistNameModelCopyWithImpl(this._self, this._then);

  final UpdateChecklistNameModel _self;
  final $Res Function(UpdateChecklistNameModel) _then;

/// Create a copy of UpdateChecklistNameModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checklistId = null,Object? checklistName = null,}) {
  return _then(_self.copyWith(
checklistId: null == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String,checklistName: null == checklistName ? _self.checklistName : checklistName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChecklistNameModel].
extension UpdateChecklistNameModelPatterns on UpdateChecklistNameModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChecklistNameModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChecklistNameModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChecklistNameModel value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChecklistNameModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChecklistNameModel value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChecklistNameModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'checklist_id')  String checklistId, @JsonKey(name: 'checklist_name')  String checklistName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChecklistNameModel() when $default != null:
return $default(_that.checklistId,_that.checklistName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'checklist_id')  String checklistId, @JsonKey(name: 'checklist_name')  String checklistName)  $default,) {final _that = this;
switch (_that) {
case _UpdateChecklistNameModel():
return $default(_that.checklistId,_that.checklistName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'checklist_id')  String checklistId, @JsonKey(name: 'checklist_name')  String checklistName)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChecklistNameModel() when $default != null:
return $default(_that.checklistId,_that.checklistName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChecklistNameModel implements UpdateChecklistNameModel {
  const _UpdateChecklistNameModel({@JsonKey(name: 'checklist_id') required this.checklistId, @JsonKey(name: 'checklist_name') required this.checklistName});
  factory _UpdateChecklistNameModel.fromJson(Map<String, dynamic> json) => _$UpdateChecklistNameModelFromJson(json);

@override@JsonKey(name: 'checklist_id') final  String checklistId;
@override@JsonKey(name: 'checklist_name') final  String checklistName;

/// Create a copy of UpdateChecklistNameModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChecklistNameModelCopyWith<_UpdateChecklistNameModel> get copyWith => __$UpdateChecklistNameModelCopyWithImpl<_UpdateChecklistNameModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChecklistNameModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChecklistNameModel&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.checklistName, checklistName) || other.checklistName == checklistName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checklistId,checklistName);

@override
String toString() {
  return 'UpdateChecklistNameModel(checklistId: $checklistId, checklistName: $checklistName)';
}


}

/// @nodoc
abstract mixin class _$UpdateChecklistNameModelCopyWith<$Res> implements $UpdateChecklistNameModelCopyWith<$Res> {
  factory _$UpdateChecklistNameModelCopyWith(_UpdateChecklistNameModel value, $Res Function(_UpdateChecklistNameModel) _then) = __$UpdateChecklistNameModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'checklist_id') String checklistId,@JsonKey(name: 'checklist_name') String checklistName
});




}
/// @nodoc
class __$UpdateChecklistNameModelCopyWithImpl<$Res>
    implements _$UpdateChecklistNameModelCopyWith<$Res> {
  __$UpdateChecklistNameModelCopyWithImpl(this._self, this._then);

  final _UpdateChecklistNameModel _self;
  final $Res Function(_UpdateChecklistNameModel) _then;

/// Create a copy of UpdateChecklistNameModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checklistId = null,Object? checklistName = null,}) {
  return _then(_UpdateChecklistNameModel(
checklistId: null == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String,checklistName: null == checklistName ? _self.checklistName : checklistName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
