import 'package:flutter/material.dart';
import 'package:teardrop/src/shared/constants/emotion_tags.dart';
import 'package:teardrop/src/theme.dart';

/// Multi-select emotion tag chips.
class EmotionTagChips extends StatelessWidget {
  const EmotionTagChips({
    super.key,
    required this.selectedTags,
    required this.onChanged,
  });

  final List<String> selectedTags;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: EmotionTags.all.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            final newTags = List<String>.from(selectedTags);
            if (selected) {
              newTags.add(tag);
            } else {
              newTags.remove(tag);
            }
            onChanged(newTags);
          },
          selectedColor: TearDropTheme.primary.withValues(alpha: 0.1),
          checkmarkColor: TearDropTheme.primary,
          labelStyle: TextStyle(
            fontSize: 13,
            color: isSelected ? TearDropTheme.primary : TearDropTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? TearDropTheme.primary.withValues(alpha: 0.4) : TearDropTheme.border,
            ),
          ),
        );
      }).toList(),
    );
  }
}
