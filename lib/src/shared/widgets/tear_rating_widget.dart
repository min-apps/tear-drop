import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 4-point behavioral anchor tear intensity scale (0-3).
///
/// Each level corresponds to an observable physiological response:
///   0 = No tears
///   1 = Eyes moistened
///   2 = Tears welled up
///   3 = Tears flowed
class TearRatingWidget extends StatelessWidget {
  const TearRatingWidget({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final int? rating;
  final ValueChanged<int> onChanged;

  static const List<TearLevel> levels = [
    TearLevel(value: 0, emoji: '😐', label: '안 남', description: '눈물 반응 없음'),
    TearLevel(value: 1, emoji: '💧', label: '촉촉', description: '눈에 수분감'),
    TearLevel(value: 2, emoji: '🥲', label: '글썽', description: '눈물이 고임'),
    TearLevel(value: 3, emoji: '😭', label: '울었다', description: '눈물이 흐름'),
  ];

  static String labelFor(int rating) {
    if (rating < 0 || rating > 3) return '';
    return levels[rating].label;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: levels.map((level) {
        final isSelected = rating == level.value;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onChanged(level.value);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.1),
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    level.emoji,
                    style: TextStyle(fontSize: isSelected ? 32 : 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TearLevel {
  const TearLevel({
    required this.value,
    required this.emoji,
    required this.label,
    required this.description,
  });
  final int value;
  final String emoji;
  final String label;
  final String description;
}
