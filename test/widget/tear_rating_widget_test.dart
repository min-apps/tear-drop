import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/shared/widgets/tear_rating_widget.dart';

void main() {
  group('TearRatingWidget', () {
    testWidgets('renders 4 tear levels', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: null,
            onChanged: (_) {},
          ),
        ),
      ));

      expect(find.text('안 남'), findsOneWidget);
      expect(find.text('촉촉'), findsOneWidget);
      expect(find.text('글썽'), findsOneWidget);
      expect(find.text('울었다'), findsOneWidget);
    });

    testWidgets('tapping selects rating', (tester) async {
      int? selectedRating;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: selectedRating,
            onChanged: (r) => selectedRating = r,
          ),
        ),
      ));

      await tester.tap(find.text('글썽'));
      expect(selectedRating, 2);
    });

    testWidgets('tapping first option selects 0', (tester) async {
      int? selectedRating;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: null,
            onChanged: (r) => selectedRating = r,
          ),
        ),
      ));

      await tester.tap(find.text('안 남'));
      expect(selectedRating, 0);
    });

    testWidgets('tapping last option selects 3', (tester) async {
      int? selectedRating;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TearRatingWidget(
            rating: null,
            onChanged: (r) => selectedRating = r,
          ),
        ),
      ));

      await tester.tap(find.text('울었다'));
      expect(selectedRating, 3);
    });

    test('labelFor returns correct labels', () {
      expect(TearRatingWidget.labelFor(0), '안 남');
      expect(TearRatingWidget.labelFor(1), '촉촉');
      expect(TearRatingWidget.labelFor(2), '글썽');
      expect(TearRatingWidget.labelFor(3), '울었다');
      expect(TearRatingWidget.labelFor(-1), '');
      expect(TearRatingWidget.labelFor(4), '');
    });
  });
}
