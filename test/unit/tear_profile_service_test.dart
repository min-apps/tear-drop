import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/data/services/tear_profile_service.dart';

void main() {
  group('TearProfileService', () {
    group('deriveTearType', () {
      test('returns default for empty user', () {
        final user = AppUser(
          uid: 'test',
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );
        expect(TearProfileService.deriveTearType(user), '눈물 초보');
      });

      test('returns correct type for top tag', () {
        final user = AppUser(
          uid: 'test',
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
          totalReactions: 5,
          emotionTagCounts: {'감동': 3, '이별': 2},
        );
        expect(TearProfileService.deriveTearType(user), '감동형 울보');
      });

      test('returns type for single tag', () {
        final user = AppUser(
          uid: 'test',
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
          totalReactions: 1,
          emotionTagCounts: {'동물': 1},
        );
        expect(TearProfileService.deriveTearType(user), '동물형 울보');
      });
    });

    group('computeNewAverage', () {
      test('returns new rating when count is 0', () {
        expect(TearProfileService.computeNewAverage(0, 0, 5), 5.0);
      });

      test('computes correct running average', () {
        expect(TearProfileService.computeNewAverage(3.0, 2, 6), 4.0);
      });

      test('handles single previous rating', () {
        expect(TearProfileService.computeNewAverage(4.0, 1, 2), 3.0);
      });
    });

    group('getEmotionDistribution', () {
      test('returns empty for empty counts', () {
        expect(TearProfileService.getEmotionDistribution({}), isEmpty);
      });

      test('returns correct percentages', () {
        final dist = TearProfileService.getEmotionDistribution({
          '감동': 3,
          '이별': 1,
        });
        expect(dist['감동'], 0.75);
        expect(dist['이별'], 0.25);
      });

      test('handles single tag', () {
        final dist = TearProfileService.getEmotionDistribution({'가족': 5});
        expect(dist['가족'], 1.0);
      });
    });
  });
}
