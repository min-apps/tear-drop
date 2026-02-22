// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedLink _$SavedLinkFromJson(Map<String, dynamic> json) {
  return _SavedLink.fromJson(json);
}

/// @nodoc
mixin _$SavedLink {
  String get id => throw _privateConstructorUsedError;
  String get youtubeId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get savedAt => throw _privateConstructorUsedError;
  String? get userNote => throw _privateConstructorUsedError;
  int? get tearRating => throw _privateConstructorUsedError;

  /// Serializes this SavedLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedLinkCopyWith<SavedLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedLinkCopyWith<$Res> {
  factory $SavedLinkCopyWith(SavedLink value, $Res Function(SavedLink) then) =
      _$SavedLinkCopyWithImpl<$Res, SavedLink>;
  @useResult
  $Res call(
      {String id,
      String youtubeId,
      String userId,
      @TimestampConverter() DateTime savedAt,
      String? userNote,
      int? tearRating});
}

/// @nodoc
class _$SavedLinkCopyWithImpl<$Res, $Val extends SavedLink>
    implements $SavedLinkCopyWith<$Res> {
  _$SavedLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? youtubeId = null,
    Object? userId = null,
    Object? savedAt = null,
    Object? userNote = freezed,
    Object? tearRating = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
      tearRating: freezed == tearRating
          ? _value.tearRating
          : tearRating // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedLinkImplCopyWith<$Res>
    implements $SavedLinkCopyWith<$Res> {
  factory _$$SavedLinkImplCopyWith(
          _$SavedLinkImpl value, $Res Function(_$SavedLinkImpl) then) =
      __$$SavedLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String youtubeId,
      String userId,
      @TimestampConverter() DateTime savedAt,
      String? userNote,
      int? tearRating});
}

/// @nodoc
class __$$SavedLinkImplCopyWithImpl<$Res>
    extends _$SavedLinkCopyWithImpl<$Res, _$SavedLinkImpl>
    implements _$$SavedLinkImplCopyWith<$Res> {
  __$$SavedLinkImplCopyWithImpl(
      _$SavedLinkImpl _value, $Res Function(_$SavedLinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? youtubeId = null,
    Object? userId = null,
    Object? savedAt = null,
    Object? userNote = freezed,
    Object? tearRating = freezed,
  }) {
    return _then(_$SavedLinkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
      tearRating: freezed == tearRating
          ? _value.tearRating
          : tearRating // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedLinkImpl implements _SavedLink {
  const _$SavedLinkImpl(
      {required this.id,
      required this.youtubeId,
      required this.userId,
      @TimestampConverter() required this.savedAt,
      this.userNote,
      this.tearRating});

  factory _$SavedLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedLinkImplFromJson(json);

  @override
  final String id;
  @override
  final String youtubeId;
  @override
  final String userId;
  @override
  @TimestampConverter()
  final DateTime savedAt;
  @override
  final String? userNote;
  @override
  final int? tearRating;

  @override
  String toString() {
    return 'SavedLink(id: $id, youtubeId: $youtubeId, userId: $userId, savedAt: $savedAt, userNote: $userNote, tearRating: $tearRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.youtubeId, youtubeId) ||
                other.youtubeId == youtubeId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.userNote, userNote) ||
                other.userNote == userNote) &&
            (identical(other.tearRating, tearRating) ||
                other.tearRating == tearRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, youtubeId, userId, savedAt, userNote, tearRating);

  /// Create a copy of SavedLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedLinkImplCopyWith<_$SavedLinkImpl> get copyWith =>
      __$$SavedLinkImplCopyWithImpl<_$SavedLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedLinkImplToJson(
      this,
    );
  }
}

abstract class _SavedLink implements SavedLink {
  const factory _SavedLink(
      {required final String id,
      required final String youtubeId,
      required final String userId,
      @TimestampConverter() required final DateTime savedAt,
      final String? userNote,
      final int? tearRating}) = _$SavedLinkImpl;

  factory _SavedLink.fromJson(Map<String, dynamic> json) =
      _$SavedLinkImpl.fromJson;

  @override
  String get id;
  @override
  String get youtubeId;
  @override
  String get userId;
  @override
  @TimestampConverter()
  DateTime get savedAt;
  @override
  String? get userNote;
  @override
  int? get tearRating;

  /// Create a copy of SavedLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedLinkImplCopyWith<_$SavedLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
