import 'package:intl/intl.dart';

/// Calculates estimated artificial tear cost savings from natural crying.
///
/// Assumptions (based on Korean pharmacy averages):
/// - Average artificial tear drop: 0.4mL
/// - Average bottle (15mL): ~8,000 KRW (일회용: ~500 KRW/개)
/// - Recommended usage: 4-6 drops/day for dry eye patients
/// - One natural crying session ≈ 2-5 drops worth of moisture
/// - Average cost per drop: ~213 KRW (8,000 / 37.5 drops per bottle)
///
/// Conservative estimate: each video watched with tear rating >= 3
/// saves approximately 2 artificial tear drops.
class TearSavingsService {
  /// Average price of a 15mL artificial tear bottle in KRW.
  static const int bottlePriceKrw = 8000;

  /// Drops per bottle (15mL / 0.4mL per drop).
  static const double dropsPerBottle = 37.5;

  /// Cost per single artificial tear drop in KRW.
  static double get costPerDropKrw => bottlePriceKrw / dropsPerBottle;

  /// Estimated natural tear drops produced per crying session by rating.
  static int dropsPerSession(int tearRating) {
    switch (tearRating) {
      case 1:
        return 0; // 눈물 없음
      case 2:
        return 1; // 살짝 촉촉
      case 3:
        return 2; // 눈물 글썽
      case 4:
        return 4; // 주르륵
      case 5:
        return 6; // 폭풍 눈물
      default:
        return 0;
    }
  }

  /// Calculate total savings from user's reaction history.
  static TearSavingsData calculate({
    required int totalReactions,
    required double averageTearRating,
    required int totalVideosWatched,
    required DateTime joinedAt,
  }) {
    // Estimate total natural drops produced
    final avgDropsPerSession =
        dropsPerSession(averageTearRating.round().clamp(1, 5));
    final totalNaturalDrops = totalReactions * avgDropsPerSession;

    // Cost savings
    final totalSavingsKrw = totalNaturalDrops * costPerDropKrw;

    // Bottles saved
    final bottlesSaved = totalNaturalDrops / dropsPerBottle;

    // Project monthly savings
    final daysSinceJoined =
        DateTime.now().difference(joinedAt).inDays.clamp(1, 99999);
    final reactionsPerDay = totalReactions / daysSinceJoined;
    final monthlySavingsKrw =
        reactionsPerDay * 30 * avgDropsPerSession * costPerDropKrw;

    // Yearly projection
    final yearlySavingsKrw = monthlySavingsKrw * 12;

    return TearSavingsData(
      totalNaturalDrops: totalNaturalDrops,
      totalSavingsKrw: totalSavingsKrw,
      bottlesSaved: bottlesSaved,
      monthlySavingsKrw: monthlySavingsKrw,
      yearlySavingsKrw: yearlySavingsKrw,
      daysSinceJoined: daysSinceJoined,
    );
  }

  static String formatKrw(double amount) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    return '${formatter.format(amount.round())}원';
  }
}

class TearSavingsData {
  const TearSavingsData({
    required this.totalNaturalDrops,
    required this.totalSavingsKrw,
    required this.bottlesSaved,
    required this.monthlySavingsKrw,
    required this.yearlySavingsKrw,
    required this.daysSinceJoined,
  });

  final int totalNaturalDrops;
  final double totalSavingsKrw;
  final double bottlesSaved;
  final double monthlySavingsKrw;
  final double yearlySavingsKrw;
  final int daysSinceJoined;
}
