import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/shared/widgets/tear_rating_widget.dart';

void main() {
  group('TearRatingWidget', () {
    testWidgets('renders 5 teardrops', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: 0,
            onChanged: (_) {},
          ),
        ),
      ));

      final icons = find.byIcon(Icons.water_drop_rounded);
      expect(icons, findsNWidgets(5));
    });

    testWidgets('tapping selects rating', (tester) async {
      int selectedRating = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return TearRatingWidget(
                rating: selectedRating,
                onChanged: (r) => setState(() => selectedRating = r),
              );
            },
          ),
        ),
      ));

      // Tap the 3rd teardrop
      final icons = find.byIcon(Icons.water_drop_rounded);
      await tester.tap(icons.at(2));
      await tester.pumpAndSettle();
      expect(selectedRating, 3);
    });

    testWidgets('tapping first teardrop selects 1', (tester) async {
      int selectedRating = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: 0,
            onChanged: (r) => selectedRating = r,
          ),
        ),
      ));

      final icons = find.byIcon(Icons.water_drop_rounded);
      await tester.tap(icons.first);
      expect(selectedRating, 1);
    });

    test('labelFor returns correct labels', () {
      expect(TearRatingWidget.labelFor(1), '눈물 없음');
      expect(TearRatingWidget.labelFor(5), '폭풍 눈물');
      expect(TearRatingWidget.labelFor(0), '');
      expect(TearRatingWidget.labelFor(6), '');
    });
  });
}
