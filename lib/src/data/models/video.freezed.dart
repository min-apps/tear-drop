// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Video _$VideoFromJson(Map<String, dynamic> json) {
  return _Video.fromJson(json);
}

/// @nodoc
mixin _$Video {
  String get youtubeId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get totalViews => throw _privateConstructorUsedError;
  double get averageTearRating => throw _privateConstructorUsedError;

  /// Serializes this Video to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCopyWith<Video> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCopyWith<$Res> {
  factory $VideoCopyWith(Video value, $Res Function(Video) then) =
      _$VideoCopyWithImpl<$Res, Video>;
  @useResult
  $Res call(
      {String youtubeId,
      String title,
      String category,
      List<String> tags,
      int totalViews,
      double averageTearRating});
}

/// @nodoc
class _$VideoCopyWithImpl<$Res, $Val extends Video>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? youtubeId = null,
    Object? title = null,
    Object? category = null,
    Object? tags = null,
    Object? totalViews = null,
    Object? averageTearRating = null,
  }) {
    return _then(_value.copyWith(
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalViews: null == totalViews
          ? _value.totalViews
          : totalViews // ignore: cast_nullable_to_non_nullable
              as int,
      averageTearRating: null == averageTearRating
          ? _value.averageTearRating
          : averageTearRating // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoImplCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$$VideoImplCopyWith(
          _$VideoImpl value, $Res Function(_$VideoImpl) then) =
      __$$VideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String youtubeId,
      String title,
      String category,
      List<String> tags,
      int totalViews,
      double averageTearRating});
}

/// @nodoc
class __$$VideoImplCopyWithImpl<$Res>
    extends _$VideoCopyWithImpl<$Res, _$VideoImpl>
    implements _$$VideoImplCopyWith<$Res> {
  __$$VideoImplCopyWithImpl(
      _$VideoImpl _value, $Res Function(_$VideoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? youtubeId = null,
    Object? title = null,
    Object? category = null,
    Object? tags = null,
    Object? totalViews = null,
    Object? averageTearRating = null,
  }) {
    return _then(_$VideoImpl(
      youtubeId: null == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalViews: null == totalViews
          ? _value.totalViews
          : totalViews // ignore: cast_nullable_to_non_nullable
              as int,
      averageTearRating: null == averageTearRating
          ? _value.averageTearRating
          : averageTearRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoImpl implements _Video {
  const _$VideoImpl(
      {required this.youtubeId,
      required this.title,
      this.category = '',
      final List<String> tags = const [],
      this.totalViews = 0,
      this.averageTearRating = 0.0})
      : _tags = tags;

  factory _$VideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoImplFromJson(json);

  @override
  final String youtubeId;
  @override
  final String title;
  @override
  @JsonKey()
  final String category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int totalViews;
  @override
  @JsonKey()
  final double averageTearRating;

  @override
  String toString() {
    return 'Video(youtubeId: $youtubeId, title: $title, category: $category, tags: $tags, totalViews: $totalViews, averageTearRating: $averageTearRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoImpl &&
            (identical(other.youtubeId, youtubeId) ||
                other.youtubeId == youtubeId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.totalViews, totalViews) ||
                other.totalViews == totalViews) &&
            (identical(other.averageTearRating, averageTearRating) ||
                other.averageTearRating == averageTearRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      youtubeId,
      title,
      category,
      const DeepCollectionEquality().hash(_tags),
      totalViews,
      averageTearRating);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      __$$VideoImplCopyWithImpl<_$VideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoImplToJson(
      this,
    );
  }
}

abstract class _Video implements Video {
  const factory _Video(
      {required final String youtubeId,
      required final String title,
      final String category,
      final List<String> tags,
      final int totalViews,
      final double averageTearRating}) = _$VideoImpl;

  factory _Video.fromJson(Map<String, dynamic> json) = _$VideoImpl.fromJson;

  @override
  String get youtubeId;
  @override
  String get title;
  @override
  String get category;
  @override
  List<String> get tags;
  @override
  int get totalViews;
  @override
  double get averageTearRating;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
