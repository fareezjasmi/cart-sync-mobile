// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_relationship_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyRelationshipModel {

@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'family_id') String? get familyId;
/// Create a copy of FamilyRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyRelationshipModelCopyWith<FamilyRelationshipModel> get copyWith => _$FamilyRelationshipModelCopyWithImpl<FamilyRelationshipModel>(this as FamilyRelationshipModel, _$identity);

  /// Serializes this FamilyRelationshipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyRelationshipModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.familyId, familyId) || other.familyId == familyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,familyId);

@override
String toString() {
  return 'FamilyRelationshipModel(userId: $userId, familyId: $familyId)';
}


}

/// @nodoc
abstract mixin class $FamilyRelationshipModelCopyWith<$Res>  {
  factory $FamilyRelationshipModelCopyWith(FamilyRelationshipModel value, $Res Function(FamilyRelationshipModel) _then) = _$FamilyRelationshipModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'family_id') String? familyId
});




}
/// @nodoc
class _$FamilyRelationshipModelCopyWithImpl<$Res>
    implements $FamilyRelationshipModelCopyWith<$Res> {
  _$FamilyRelationshipModelCopyWithImpl(this._self, this._then);

  final FamilyRelationshipModel _self;
  final $Res Function(FamilyRelationshipModel) _then;

/// Create a copy of FamilyRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? familyId = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyRelationshipModel].
extension FamilyRelationshipModelPatterns on FamilyRelationshipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyRelationshipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyRelationshipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyRelationshipModel value)  $default,){
final _that = this;
switch (_that) {
case _FamilyRelationshipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyRelationshipModel value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyRelationshipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'family_id')  String? familyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyRelationshipModel() when $default != null:
return $default(_that.userId,_that.familyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'family_id')  String? familyId)  $default,) {final _that = this;
switch (_that) {
case _FamilyRelationshipModel():
return $default(_that.userId,_that.familyId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'family_id')  String? familyId)?  $default,) {final _that = this;
switch (_that) {
case _FamilyRelationshipModel() when $default != null:
return $default(_that.userId,_that.familyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyRelationshipModel implements FamilyRelationshipModel {
  const _FamilyRelationshipModel({@JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'family_id') this.familyId});
  factory _FamilyRelationshipModel.fromJson(Map<String, dynamic> json) => _$FamilyRelationshipModelFromJson(json);

@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'family_id') final  String? familyId;

/// Create a copy of FamilyRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyRelationshipModelCopyWith<_FamilyRelationshipModel> get copyWith => __$FamilyRelationshipModelCopyWithImpl<_FamilyRelationshipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyRelationshipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyRelationshipModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.familyId, familyId) || other.familyId == familyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,familyId);

@override
String toString() {
  return 'FamilyRelationshipModel(userId: $userId, familyId: $familyId)';
}


}

/// @nodoc
abstract mixin class _$FamilyRelationshipModelCopyWith<$Res> implements $FamilyRelationshipModelCopyWith<$Res> {
  factory _$FamilyRelationshipModelCopyWith(_FamilyRelationshipModel value, $Res Function(_FamilyRelationshipModel) _then) = __$FamilyRelationshipModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'family_id') String? familyId
});




}
/// @nodoc
class __$FamilyRelationshipModelCopyWithImpl<$Res>
    implements _$FamilyRelationshipModelCopyWith<$Res> {
  __$FamilyRelationshipModelCopyWithImpl(this._self, this._then);

  final _FamilyRelationshipModel _self;
  final $Res Function(_FamilyRelationshipModel) _then;

/// Create a copy of FamilyRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? familyId = freezed,}) {
  return _then(_FamilyRelationshipModel(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
