import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_collection.freezed.dart';
part 'preset_collection.g.dart';

@freezed
class PresetCollection with _$PresetCollection {
  const factory PresetCollection({
    required String id,
    required String title,
    required String subtitle,
    required String emoji,
    required List<String> videoIds,
  }) = _PresetCollection;

  factory PresetCollection.fromJson(Map<String, dynamic> json) =>
      _$PresetCollectionFromJson(json);
}
