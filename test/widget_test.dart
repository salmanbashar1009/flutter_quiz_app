import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_quiz_app/main.dart';

void main() {
  testWidgets('App launches and shows first screen', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows the expected first screen content.
    // Adjust the text below to match what appears on your home/quiz start screen.
    expect(find.text('Start Quiz'), findsOneWidget);
  });
}
