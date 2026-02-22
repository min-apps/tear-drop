import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/shared/constants/emotion_tags.dart';
import 'package:teardrop/src/shared/widgets/emotion_tag_chips.dart';

void main() {
  group('EmotionTagChips', () {
    testWidgets('renders all emotion tags', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EmotionTagChips(
            selectedTags: const [],
            onChanged: (_) {},
          ),
        ),
      ));

      for (final tag in EmotionTags.all) {
        expect(find.text(tag), findsOneWidget);
      }
    });

    testWidgets('multi-select works', (tester) async {
      List<String> selected = [];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return EmotionTagChips(
                selectedTags: selected,
                onChanged: (tags) => setState(() => selected = tags),
              );
            },
          ),
        ),
      ));

      // Select two tags
      await tester.tap(find.text('감동'));
      await tester.pumpAndSettle();
      expect(selected, ['감동']);

      await tester.tap(find.text('이별'));
      await tester.pumpAndSettle();
      expect(selected, ['감동', '이별']);
    });

    testWidgets('deselect works', (tester) async {
      List<String> selected = ['감동'];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return EmotionTagChips(
                selectedTags: selected,
                onChanged: (tags) => setState(() => selected = tags),
              );
            },
          ),
        ),
      ));

      await tester.tap(find.text('감동'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
    });
  });
}
