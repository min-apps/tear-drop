import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';
part 'video.g.dart';

@freezed
class Video with _$Video {
  const factory Video({
    required String youtubeId,
    required String title,
    @Default('') String category,
    @Default([]) List<String> tags,
    @Default(0) int totalViews,
    @Default(0.0) double averageTearRating,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
