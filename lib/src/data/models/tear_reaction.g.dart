// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tear_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TearReactionImpl _$$TearReactionImplFromJson(Map<String, dynamic> json) =>
    _$TearReactionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      youtubeId: json['youtubeId'] as String,
      tearRating: (json['tearRating'] as num).toInt(),
      emotionTags: (json['emotionTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      watchDurationSec: (json['watchDurationSec'] as num?)?.toInt() ?? 0,
      isReplay: json['isReplay'] as bool? ?? false,
    );

Map<String, dynamic> _$$TearReactionImplToJson(_$TearReactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'youtubeId': instance.youtubeId,
      'tearRating': instance.tearRating,
      'emotionTags': instance.emotionTags,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'watchDurationSec': instance.watchDurationSec,
      'isReplay': instance.isReplay,
    };
