import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:students_async/main.dart';

void main() {
  testWidgets('Home screen shows all three buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const StudentsApp());

    // Check the app title
    expect(find.text('Practice 10'), findsOneWidget);

    // Check all three buttons
    expect(find.text('By hand'), findsOneWidget);
    expect(find.text('FutureBuilder'), findsOneWidget);
    expect(find.text('Countdown'), findsOneWidget);

    // Check the total number of buttons
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });
}
