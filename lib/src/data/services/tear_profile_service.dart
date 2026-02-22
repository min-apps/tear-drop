import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/shared/constants/emotion_tags.dart';

class TearProfileService {
  /// Derives the user's tear type label from their emotion tag counts.
  static String deriveTearType(AppUser user) {
    if (user.emotionTagCounts.isEmpty || user.totalReactions == 0) {
      return EmotionTags.tearTypeLabel('');
    }
    final topTag = _getTopTag(user.emotionTagCounts);
    return EmotionTags.tearTypeLabel(topTag);
  }

  /// Gets the emoji for the user's tear type.
  static String deriveTearEmoji(AppUser user) {
    if (user.emotionTagCounts.isEmpty || user.totalReactions == 0) {
      return EmotionTags.tearTypeEmoji('');
    }
    final topTag = _getTopTag(user.emotionTagCounts);
    return EmotionTags.tearTypeEmoji(topTag);
  }

  /// Computes the new running average tear rating after a new reaction.
  static double computeNewAverage(
    double currentAverage,
    int currentCount,
    int newRating,
  ) {
    if (currentCount == 0) return newRating.toDouble();
    return (currentAverage * currentCount + newRating) / (currentCount + 1);
  }

  /// Returns the emotion tag distribution as percentages (0.0 - 1.0).
  static Map<String, double> getEmotionDistribution(
      Map<String, int> tagCounts) {
    if (tagCounts.isEmpty) return {};
    final total = tagCounts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return {};
    return tagCounts.map((key, value) => MapEntry(key, value / total));
  }

  static String _getTopTag(Map<String, int> tagCounts) {
    String topTag = '';
    int topCount = 0;
    for (final entry in tagCounts.entries) {
      if (entry.value > topCount) {
        topCount = entry.value;
        topTag = entry.key;
      }
    }
    return topTag;
  }
}
