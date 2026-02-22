// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PresetCollection _$PresetCollectionFromJson(Map<String, dynamic> json) {
  return _PresetCollection.fromJson(json);
}

/// @nodoc
mixin _$PresetCollection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  List<String> get videoIds => throw _privateConstructorUsedError;

  /// Serializes this PresetCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresetCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetCollectionCopyWith<PresetCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetCollectionCopyWith<$Res> {
  factory $PresetCollectionCopyWith(
          PresetCollection value, $Res Function(PresetCollection) then) =
      _$PresetCollectionCopyWithImpl<$Res, PresetCollection>;
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String emoji,
      List<String> videoIds});
}

/// @nodoc
class _$PresetCollectionCopyWithImpl<$Res, $Val extends PresetCollection>
    implements $PresetCollectionCopyWith<$Res> {
  _$PresetCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? emoji = null,
    Object? videoIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      videoIds: null == videoIds
          ? _value.videoIds
          : videoIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PresetCollectionImplCopyWith<$Res>
    implements $PresetCollectionCopyWith<$Res> {
  factory _$$PresetCollectionImplCopyWith(_$PresetCollectionImpl value,
          $Res Function(_$PresetCollectionImpl) then) =
      __$$PresetCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String emoji,
      List<String> videoIds});
}

/// @nodoc
class __$$PresetCollectionImplCopyWithImpl<$Res>
    extends _$PresetCollectionCopyWithImpl<$Res, _$PresetCollectionImpl>
    implements _$$PresetCollectionImplCopyWith<$Res> {
  __$$PresetCollectionImplCopyWithImpl(_$PresetCollectionImpl _value,
      $Res Function(_$PresetCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PresetCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? emoji = null,
    Object? videoIds = null,
  }) {
    return _then(_$PresetCollectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      videoIds: null == videoIds
          ? _value._videoIds
          : videoIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetCollectionImpl implements _PresetCollection {
  const _$PresetCollectionImpl(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.emoji,
      required final List<String> videoIds})
      : _videoIds = videoIds;

  factory _$PresetCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetCollectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String emoji;
  final List<String> _videoIds;
  @override
  List<String> get videoIds {
    if (_videoIds is EqualUnmodifiableListView) return _videoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoIds);
  }

  @override
  String toString() {
    return 'PresetCollection(id: $id, title: $title, subtitle: $subtitle, emoji: $emoji, videoIds: $videoIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetCollectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            const DeepCollectionEquality().equals(other._videoIds, _videoIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, subtitle, emoji,
      const DeepCollectionEquality().hash(_videoIds));

  /// Create a copy of PresetCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetCollectionImplCopyWith<_$PresetCollectionImpl> get copyWith =>
      __$$PresetCollectionImplCopyWithImpl<_$PresetCollectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetCollectionImplToJson(
      this,
    );
  }
}

abstract class _PresetCollection implements PresetCollection {
  const factory _PresetCollection(
      {required final String id,
      required final String title,
      required final String subtitle,
      required final String emoji,
      required final List<String> videoIds}) = _$PresetCollectionImpl;

  factory _PresetCollection.fromJson(Map<String, dynamic> json) =
      _$PresetCollectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get emoji;
  @override
  List<String> get videoIds;

  /// Create a copy of PresetCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetCollectionImplCopyWith<_$PresetCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
