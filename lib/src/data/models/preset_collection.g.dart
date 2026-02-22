// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PresetCollectionImpl _$$PresetCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PresetCollectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      emoji: json['emoji'] as String,
      videoIds:
          (json['videoIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PresetCollectionImplToJson(
        _$PresetCollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'emoji': instance.emoji,
      'videoIds': instance.videoIds,
    };
