import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teardrop/src/theme.dart';

/// A 1-5 teardrop rating selector.
class TearRatingWidget extends StatelessWidget {
  const TearRatingWidget({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 40,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final level = index + 1;
        final isSelected = level <= rating;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onChanged(level);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              child: Icon(
                Icons.water_drop_rounded,
                size: size,
                color: isSelected
                    ? TearDropTheme.primary
                    : TearDropTheme.border,
              ),
            ),
          ),
        );
      }),
    );
  }

  static const List<String> labels = [
    '눈물 없음',
    '살짝 촉촉',
    '눈물 글썽',
    '주르륵',
    '폭풍 눈물',
  ];

  static String labelFor(int rating) {
    if (rating < 1 || rating > 5) return '';
    return labels[rating - 1];
  }
}
