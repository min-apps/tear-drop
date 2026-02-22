import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teardrop/src/data/models/app_user.dart';

part 'tear_reaction.freezed.dart';
part 'tear_reaction.g.dart';

@freezed
class TearReaction with _$TearReaction {
  const factory TearReaction({
    required String id,
    required String userId,
    required String youtubeId,
    required int tearRating,
    @Default([]) List<String> emotionTags,
    @TimestampConverter() required DateTime createdAt,
    @Default(0) int watchDurationSec,
    @Default(false) bool isReplay,
  }) = _TearReaction;

  factory TearReaction.fromJson(Map<String, dynamic> json) =>
      _$TearReactionFromJson(json);
}
