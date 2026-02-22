// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedLinkImpl _$$SavedLinkImplFromJson(Map<String, dynamic> json) =>
    _$SavedLinkImpl(
      id: json['id'] as String,
      youtubeId: json['youtubeId'] as String,
      userId: json['userId'] as String,
      savedAt: const TimestampConverter().fromJson(json['savedAt']),
      userNote: json['userNote'] as String?,
      tearRating: (json['tearRating'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SavedLinkImplToJson(_$SavedLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'youtubeId': instance.youtubeId,
      'userId': instance.userId,
      'savedAt': const TimestampConverter().toJson(instance.savedAt),
      'userNote': instance.userNote,
      'tearRating': instance.tearRating,
    };
