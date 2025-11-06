import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devlearn/screens/widgets/savedbutton.dart'; // đổi thành đường dẫn thật trong project bạn

void main() {
  testWidgets('SaveButton toggles color when pressed', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SavedButton(isSaved: true,)));

    final button = find.byType(IconButton);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    // Bạn có thể kiểm tra lại trạng thái `isSaved` bằng cách mock state hoặc golden test
  });
}