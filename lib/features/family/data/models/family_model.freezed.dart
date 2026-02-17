// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyModel {

@JsonKey(name: 'family_id') String? get familyId;@JsonKey(name: 'admin_id') String? get adminId; String? get name;@JsonKey(name: 'date_created') String? get dateCreated;@JsonKey(name: 'last_updated') String? get lastUpdated;
/// Create a copy of FamilyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyModelCopyWith<FamilyModel> get copyWith => _$FamilyModelCopyWithImpl<FamilyModel>(this as FamilyModel, _$identity);

  /// Serializes this FamilyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyModel&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.adminId, adminId) || other.adminId == adminId)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,adminId,name,dateCreated,lastUpdated);

@override
String toString() {
  return 'FamilyModel(familyId: $familyId, adminId: $adminId, name: $name, dateCreated: $dateCreated, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $FamilyModelCopyWith<$Res>  {
  factory $FamilyModelCopyWith(FamilyModel value, $Res Function(FamilyModel) _then) = _$FamilyModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'family_id') String? familyId,@JsonKey(name: 'admin_id') String? adminId, String? name,@JsonKey(name: 'date_created') String? dateCreated,@JsonKey(name: 'last_updated') String? lastUpdated
});




}
/// @nodoc
class _$FamilyModelCopyWithImpl<$Res>
    implements $FamilyModelCopyWith<$Res> {
  _$FamilyModelCopyWithImpl(this._self, this._then);

  final FamilyModel _self;
  final $Res Function(FamilyModel) _then;

/// Create a copy of FamilyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = freezed,Object? adminId = freezed,Object? name = freezed,Object? dateCreated = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,adminId: freezed == adminId ? _self.adminId : adminId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,dateCreated: freezed == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyModel].
extension FamilyModelPatterns on FamilyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyModel value)  $default,){
final _that = this;
switch (_that) {
case _FamilyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyModel value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'admin_id')  String? adminId,  String? name, @JsonKey(name: 'date_created')  String? dateCreated, @JsonKey(name: 'last_updated')  String? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyModel() when $default != null:
return $default(_that.familyId,_that.adminId,_that.name,_that.dateCreated,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'admin_id')  String? adminId,  String? name, @JsonKey(name: 'date_created')  String? dateCreated, @JsonKey(name: 'last_updated')  String? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _FamilyModel():
return $default(_that.familyId,_that.adminId,_that.name,_that.dateCreated,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'family_id')  String? familyId, @JsonKey(name: 'admin_id')  String? adminId,  String? name, @JsonKey(name: 'date_created')  String? dateCreated, @JsonKey(name: 'last_updated')  String? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _FamilyModel() when $default != null:
return $default(_that.familyId,_that.adminId,_that.name,_that.dateCreated,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyModel implements FamilyModel {
  const _FamilyModel({@JsonKey(name: 'family_id') this.familyId, @JsonKey(name: 'admin_id') this.adminId, this.name, @JsonKey(name: 'date_created') this.dateCreated, @JsonKey(name: 'last_updated') this.lastUpdated});
  factory _FamilyModel.fromJson(Map<String, dynamic> json) => _$FamilyModelFromJson(json);

@override@JsonKey(name: 'family_id') final  String? familyId;
@override@JsonKey(name: 'admin_id') final  String? adminId;
@override final  String? name;
@override@JsonKey(name: 'date_created') final  String? dateCreated;
@override@JsonKey(name: 'last_updated') final  String? lastUpdated;

/// Create a copy of FamilyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyModelCopyWith<_FamilyModel> get copyWith => __$FamilyModelCopyWithImpl<_FamilyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyModel&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.adminId, adminId) || other.adminId == adminId)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,adminId,name,dateCreated,lastUpdated);

@override
String toString() {
  return 'FamilyModel(familyId: $familyId, adminId: $adminId, name: $name, dateCreated: $dateCreated, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$FamilyModelCopyWith<$Res> implements $FamilyModelCopyWith<$Res> {
  factory _$FamilyModelCopyWith(_FamilyModel value, $Res Function(_FamilyModel) _then) = __$FamilyModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'family_id') String? familyId,@JsonKey(name: 'admin_id') String? adminId, String? name,@JsonKey(name: 'date_created') String? dateCreated,@JsonKey(name: 'last_updated') String? lastUpdated
});




}
/// @nodoc
class __$FamilyModelCopyWithImpl<$Res>
    implements _$FamilyModelCopyWith<$Res> {
  __$FamilyModelCopyWithImpl(this._self, this._then);

  final _FamilyModel _self;
  final $Res Function(_FamilyModel) _then;

/// Create a copy of FamilyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = freezed,Object? adminId = freezed,Object? name = freezed,Object? dateCreated = freezed,Object? lastUpdated = freezed,}) {
  return _then(_FamilyModel(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,adminId: freezed == adminId ? _self.adminId : adminId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,dateCreated: freezed == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
