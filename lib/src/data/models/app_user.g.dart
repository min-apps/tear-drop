// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      lastActiveAt: const TimestampConverter().fromJson(json['lastActiveAt']),
      totalVideosWatched: (json['totalVideosWatched'] as num?)?.toInt() ?? 0,
      totalReactions: (json['totalReactions'] as num?)?.toInt() ?? 0,
      emotionTagCounts:
          (json['emotionTagCounts'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      averageTearRating: (json['averageTearRating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'lastActiveAt': const TimestampConverter().toJson(instance.lastActiveAt),
      'totalVideosWatched': instance.totalVideosWatched,
      'totalReactions': instance.totalReactions,
      'emotionTagCounts': instance.emotionTagCounts,
      'averageTearRating': instance.averageTearRating,
    };
