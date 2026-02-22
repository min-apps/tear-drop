// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tear_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TearReaction _$TearReactionFromJson(Map<String, dynamic> json) {
  return _TearReaction.fromJson(json);
}

/// @nodoc
mixin _$TearReaction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get youtubeId => throw _privateConstructorUsedError;
  int get tearRating => throw _privateConstructorUsedError;
  List<String> get emotionTags => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get watchDurationSec => throw _privateConstructorUsedError;
  bool get isReplay => throw _privateConstructorUsedError;

  /// Serializes this TearReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TearReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TearReactionCopyWith<TearReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TearReactionCopyWith<$Res> {
  factory $TearReactionCopyWith(
          TearReaction value, $Res Function(TearReaction) then) =
      _$TearReactionCopyWithImpl<$Res, TearReaction>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String youtubeId,
      int tearRating,
      List<String> emotionTags,
      @TimestampConverter() DateTime createdAt,
      int watchDurationSec,
      bool isReplay});
}

/// @nodoc
class _$TearReactionCopyWithImpl<$Res, $Val extends TearReaction>
    implements $TearReactionCopyWith<$Res> {
  _$TearReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TearReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? youtubeId = null,
    Object? tearRating = null,
    Object? emotionTags = null,
    Object? createdAt = null,
    Object? watchDurationSec = null,
    Object? isReplay = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      tearRating: null == tearRating
          ? _value.tearRating
          : tearRating // ignore: cast_nullable_to_non_nullable
              as int,
      emotionTags: null == emotionTags
          ? _value.emotionTags
          : emotionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      watchDurationSec: null == watchDurationSec
          ? _value.watchDurationSec
          : watchDurationSec // ignore: cast_nullable_to_non_nullable
              as int,
      isReplay: null == isReplay
          ? _value.isReplay
          : isReplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TearReactionImplCopyWith<$Res>
    implements $TearReactionCopyWith<$Res> {
  factory _$$TearReactionImplCopyWith(
          _$TearReactionImpl value, $Res Function(_$TearReactionImpl) then) =
      __$$TearReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String youtubeId,
      int tearRating,
      List<String> emotionTags,
      @TimestampConverter() DateTime createdAt,
      int watchDurationSec,
      bool isReplay});
}

/// @nodoc
class __$$TearReactionImplCopyWithImpl<$Res>
    extends _$TearReactionCopyWithImpl<$Res, _$TearReactionImpl>
    implements _$$TearReactionImplCopyWith<$Res> {
  __$$TearReactionImplCopyWithImpl(
      _$TearReactionImpl _value, $Res Function(_$TearReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TearReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? youtubeId = null,
    Object? tearRating = null,
    Object? emotionTags = null,
    Object? createdAt = null,
    Object? watchDurationSec = null,
    Object? isReplay = null,
  }) {
    return _then(_$TearReactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      tearRating: null == tearRating
          ? _value.tearRating
          : tearRating // ignore: cast_nullable_to_non_nullable
              as int,
      emotionTags: null == emotionTags
          ? _value._emotionTags
          : emotionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      watchDurationSec: null == watchDurationSec
          ? _value.watchDurationSec
          : watchDurationSec // ignore: cast_nullable_to_non_nullable
              as int,
      isReplay: null == isReplay
          ? _value.isReplay
          : isReplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TearReactionImpl implements _TearReaction {
  const _$TearReactionImpl(
      {required this.id,
      required this.userId,
      required this.youtubeId,
      required this.tearRating,
      final List<String> emotionTags = const [],
      @TimestampConverter() required this.createdAt,
      this.watchDurationSec = 0,
      this.isReplay = false})
      : _emotionTags = emotionTags;

  factory _$TearReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TearReactionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String youtubeId;
  @override
  final int tearRating;
  final List<String> _emotionTags;
  @override
  @JsonKey()
  List<String> get emotionTags {
    if (_emotionTags is EqualUnmodifiableListView) return _emotionTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emotionTags);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @JsonKey()
  final int watchDurationSec;
  @override
  @JsonKey()
  final bool isReplay;

  @override
  String toString() {
    return 'TearReaction(id: $id, userId: $userId, youtubeId: $youtubeId, tearRating: $tearRating, emotionTags: $emotionTags, createdAt: $createdAt, watchDurationSec: $watchDurationSec, isReplay: $isReplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TearReactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.youtubeId, youtubeId) ||
                other.youtubeId == youtubeId) &&
            (identical(other.tearRating, tearRating) ||
                other.tearRating == tearRating) &&
            const DeepCollectionEquality()
                .equals(other._emotionTags, _emotionTags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.watchDurationSec, watchDurationSec) ||
                other.watchDurationSec == watchDurationSec) &&
            (identical(other.isReplay, isReplay) ||
                other.isReplay == isReplay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      youtubeId,
      tearRating,
      const DeepCollectionEquality().hash(_emotionTags),
      createdAt,
      watchDurationSec,
      isReplay);

  /// Create a copy of TearReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TearReactionImplCopyWith<_$TearReactionImpl> get copyWith =>
      __$$TearReactionImplCopyWithImpl<_$TearReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TearReactionImplToJson(
      this,
    );
  }
}

abstract class _TearReaction implements TearReaction {
  const factory _TearReaction(
      {required final String id,
      required final String userId,
      required final String youtubeId,
      required final int tearRating,
      final List<String> emotionTags,
      @TimestampConverter() required final DateTime createdAt,
      final int watchDurationSec,
      final bool isReplay}) = _$TearReactionImpl;

  factory _TearReaction.fromJson(Map<String, dynamic> json) =
      _$TearReactionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get youtubeId;
  @override
  int get tearRating;
  @override
  List<String> get emotionTags;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  int get watchDurationSec;
  @override
  bool get isReplay;

  /// Create a copy of TearReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TearReactionImplCopyWith<_$TearReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
