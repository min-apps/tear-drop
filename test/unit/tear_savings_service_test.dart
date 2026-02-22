import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/data/services/tear_savings_service.dart';

void main() {
  group('TearSavingsService', () {
    test('dropsPerSession returns correct values', () {
      expect(TearSavingsService.dropsPerSession(1), 0);
      expect(TearSavingsService.dropsPerSession(2), 1);
      expect(TearSavingsService.dropsPerSession(3), 2);
      expect(TearSavingsService.dropsPerSession(4), 4);
      expect(TearSavingsService.dropsPerSession(5), 6);
      expect(TearSavingsService.dropsPerSession(0), 0);
    });

    test('costPerDropKrw is reasonable', () {
      final cost = TearSavingsService.costPerDropKrw;
      expect(cost, greaterThan(100));
      expect(cost, lessThan(300));
    });

    test('calculate returns correct data for active user', () {
      final result = TearSavingsService.calculate(
        totalReactions: 10,
        averageTearRating: 4.0,
        totalVideosWatched: 15,
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      // 10 reactions * 4 drops (rating 4) = 40 drops
      expect(result.totalNaturalDrops, 40);
      expect(result.totalSavingsKrw, greaterThan(0));
      expect(result.bottlesSaved, greaterThan(0));
      expect(result.monthlySavingsKrw, greaterThan(0));
      expect(result.daysSinceJoined, 30);
    });

    test('calculate returns zeros for new user', () {
      final result = TearSavingsService.calculate(
        totalReactions: 0,
        averageTearRating: 0.0,
        totalVideosWatched: 0,
        joinedAt: DateTime.now(),
      );

      expect(result.totalNaturalDrops, 0);
      expect(result.totalSavingsKrw, 0);
    });

    test('formatKrw formats correctly', () {
      expect(TearSavingsService.formatKrw(8000), '8,000원');
      expect(TearSavingsService.formatKrw(0), '0원');
      expect(TearSavingsService.formatKrw(123456.7), '123,457원');
    });
  });
}
