// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get lastActiveAt => throw _privateConstructorUsedError;
  int get totalVideosWatched => throw _privateConstructorUsedError;
  int get totalReactions => throw _privateConstructorUsedError;
  Map<String, int> get emotionTagCounts => throw _privateConstructorUsedError;
  double get averageTearRating => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String uid,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime lastActiveAt,
      int totalVideosWatched,
      int totalReactions,
      Map<String, int> emotionTagCounts,
      double averageTearRating});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? createdAt = null,
    Object? lastActiveAt = null,
    Object? totalVideosWatched = null,
    Object? totalReactions = null,
    Object? emotionTagCounts = null,
    Object? averageTearRating = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalVideosWatched: null == totalVideosWatched
          ? _value.totalVideosWatched
          : totalVideosWatched // ignore: cast_nullable_to_non_nullable
              as int,
      totalReactions: null == totalReactions
          ? _value.totalReactions
          : totalReactions // ignore: cast_nullable_to_non_nullable
              as int,
      emotionTagCounts: null == emotionTagCounts
          ? _value.emotionTagCounts
          : emotionTagCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTearRating: null == averageTearRating
          ? _value.averageTearRating
          : averageTearRating // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime lastActiveAt,
      int totalVideosWatched,
      int totalReactions,
      Map<String, int> emotionTagCounts,
      double averageTearRating});
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? createdAt = null,
    Object? lastActiveAt = null,
    Object? totalVideosWatched = null,
    Object? totalReactions = null,
    Object? emotionTagCounts = null,
    Object? averageTearRating = null,
  }) {
    return _then(_$AppUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalVideosWatched: null == totalVideosWatched
          ? _value.totalVideosWatched
          : totalVideosWatched // ignore: cast_nullable_to_non_nullable
              as int,
      totalReactions: null == totalReactions
          ? _value.totalReactions
          : totalReactions // ignore: cast_nullable_to_non_nullable
              as int,
      emotionTagCounts: null == emotionTagCounts
          ? _value._emotionTagCounts
          : emotionTagCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTearRating: null == averageTearRating
          ? _value.averageTearRating
          : averageTearRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl(
      {required this.uid,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.lastActiveAt,
      this.totalVideosWatched = 0,
      this.totalReactions = 0,
      final Map<String, int> emotionTagCounts = const {},
      this.averageTearRating = 0.0})
      : _emotionTagCounts = emotionTagCounts;

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime lastActiveAt;
  @override
  @JsonKey()
  final int totalVideosWatched;
  @override
  @JsonKey()
  final int totalReactions;
  final Map<String, int> _emotionTagCounts;
  @override
  @JsonKey()
  Map<String, int> get emotionTagCounts {
    if (_emotionTagCounts is EqualUnmodifiableMapView) return _emotionTagCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emotionTagCounts);
  }

  @override
  @JsonKey()
  final double averageTearRating;

  @override
  String toString() {
    return 'AppUser(uid: $uid, createdAt: $createdAt, lastActiveAt: $lastActiveAt, totalVideosWatched: $totalVideosWatched, totalReactions: $totalReactions, emotionTagCounts: $emotionTagCounts, averageTearRating: $averageTearRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.totalVideosWatched, totalVideosWatched) ||
                other.totalVideosWatched == totalVideosWatched) &&
            (identical(other.totalReactions, totalReactions) ||
                other.totalReactions == totalReactions) &&
            const DeepCollectionEquality()
                .equals(other._emotionTagCounts, _emotionTagCounts) &&
            (identical(other.averageTearRating, averageTearRating) ||
                other.averageTearRating == averageTearRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      createdAt,
      lastActiveAt,
      totalVideosWatched,
      totalReactions,
      const DeepCollectionEquality().hash(_emotionTagCounts),
      averageTearRating);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser(
      {required final String uid,
      @TimestampConverter() required final DateTime createdAt,
      @TimestampConverter() required final DateTime lastActiveAt,
      final int totalVideosWatched,
      final int totalReactions,
      final Map<String, int> emotionTagCounts,
      final double averageTearRating}) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get lastActiveAt;
  @override
  int get totalVideosWatched;
  @override
  int get totalReactions;
  @override
  Map<String, int> get emotionTagCounts;
  @override
  double get averageTearRating;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
