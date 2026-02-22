import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime lastActiveAt,
    @Default(0) int totalVideosWatched,
    @Default(0) int totalReactions,
    @Default({}) Map<String, int> emotionTagCounts,
    @Default(0.0) double averageTearRating,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime object) => Timestamp.fromDate(object);
}
