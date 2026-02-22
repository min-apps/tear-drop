import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teardrop/src/data/models/app_user.dart';

part 'saved_link.freezed.dart';
part 'saved_link.g.dart';

@freezed
class SavedLink with _$SavedLink {
  const factory SavedLink({
    required String id,
    required String youtubeId,
    required String userId,
    @TimestampConverter() required DateTime savedAt,
    String? userNote,
    int? tearRating,
  }) = _SavedLink;

  factory SavedLink.fromJson(Map<String, dynamic> json) =>
      _$SavedLinkFromJson(json);
}
