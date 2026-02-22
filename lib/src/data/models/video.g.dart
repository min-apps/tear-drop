// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoImpl _$$VideoImplFromJson(Map<String, dynamic> json) => _$VideoImpl(
      youtubeId: json['youtubeId'] as String,
      title: json['title'] as String,
      category: json['category'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
      averageTearRating: (json['averageTearRating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$VideoImplToJson(_$VideoImpl instance) =>
    <String, dynamic>{
      'youtubeId': instance.youtubeId,
      'title': instance.title,
      'category': instance.category,
      'tags': instance.tags,
      'totalViews': instance.totalViews,
      'averageTearRating': instance.averageTearRating,
    };
