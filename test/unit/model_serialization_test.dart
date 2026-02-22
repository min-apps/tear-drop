import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/data/models/preset_collection.dart';
import 'package:teardrop/src/data/models/saved_link.dart';
import 'package:teardrop/src/data/models/tear_reaction.dart';
import 'package:teardrop/src/data/models/video.dart';

void main() {
  group('Model serialization', () {
    test('AppUser round-trip', () {
      final now = DateTime(2025, 1, 1);
      final user = AppUser(
        uid: 'test-uid',
        createdAt: now,
        lastActiveAt: now,
        totalVideosWatched: 10,
        totalReactions: 5,
        emotionTagCounts: {'감동': 3, '이별': 2},
        averageTearRating: 3.5,
      );
      final json = user.toJson();
      // TimestampConverter produces Timestamp objects
      expect(json['uid'], 'test-uid');
      expect(json['totalVideosWatched'], 10);
      expect(json['averageTearRating'], 3.5);

      // Re-create from JSON with Timestamp values
      final restored = AppUser.fromJson({
        ...json,
        'createdAt': Timestamp.fromDate(now),
        'lastActiveAt': Timestamp.fromDate(now),
      });
      expect(restored.uid, user.uid);
      expect(restored.totalReactions, user.totalReactions);
      expect(restored.emotionTagCounts, user.emotionTagCounts);
    });

    test('Video round-trip', () {
      const video = Video(
        youtubeId: 'abc123_-xyz',
        title: 'Test Video',
        category: 'test',
        tags: ['a', 'b'],
        totalViews: 100,
        averageTearRating: 4.2,
      );
      final json = video.toJson();
      final restored = Video.fromJson(json);
      expect(restored, video);
    });

    test('PresetCollection round-trip', () {
      const preset = PresetCollection(
        id: 'test',
        title: 'Test',
        subtitle: 'Sub',
        emoji: '🥹',
        videoIds: ['a', 'b'],
      );
      final json = preset.toJson();
      final restored = PresetCollection.fromJson(json);
      expect(restored, preset);
    });

    test('SavedLink round-trip', () {
      final now = DateTime(2025, 2, 1);
      final link = SavedLink(
        id: 'link-1',
        youtubeId: 'vid123abcde',
        userId: 'user-1',
        savedAt: now,
        userNote: 'great video',
        tearRating: 4,
      );
      final json = link.toJson();
      final restored = SavedLink.fromJson({
        ...json,
        'savedAt': Timestamp.fromDate(now),
      });
      expect(restored.id, link.id);
      expect(restored.youtubeId, link.youtubeId);
      expect(restored.tearRating, link.tearRating);
    });

    test('TearReaction round-trip', () {
      final now = DateTime(2025, 3, 1);
      final reaction = TearReaction(
        id: 'reaction-1',
        userId: 'user-1',
        youtubeId: 'vid123abcde',
        tearRating: 5,
        emotionTags: ['감동', '가족'],
        createdAt: now,
        watchDurationSec: 120,
        isReplay: true,
      );
      final json = reaction.toJson();
      final restored = TearReaction.fromJson({
        ...json,
        'createdAt': Timestamp.fromDate(now),
      });
      expect(restored.id, reaction.id);
      expect(restored.tearRating, reaction.tearRating);
      expect(restored.emotionTags, reaction.emotionTags);
      expect(restored.isReplay, true);
    });
  });
}
