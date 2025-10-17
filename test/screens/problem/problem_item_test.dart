import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:devlearn/core/widgets/savedbutton.dart';
import 'package:devlearn/screens/problem/problem_item.dart';
import 'package:devlearn/data/models/problem_summary.dart';

void main() {
  group('ProblemItem Widget Test', () {
    testWidgets('Hiển thị đúng thông tin cơ bản', (WidgetTester tester) async {
      // Arrange: tạo 1 ProblemSummary giả
      final problem = ProblemSummary(
        id: '1',
        title: 'Add Two Numbers',
        difficulty: 'Easy',
        acceptance: 90.5,
        saved: true,
        solved: true,
      );

      // Act: render widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemItem(problemSummary: problem),
          ),
        ),
      );

      // Assert
      expect(find.text('Add Two Numbers'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('90.5'), findsOneWidget);
      expect(find.byType(SavedButton), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget); // vì solved=false
    });

  });
}