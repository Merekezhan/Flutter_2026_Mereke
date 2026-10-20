import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maison_sucree/main.dart';

void main() {
  Future<void> openApp(WidgetTester tester) async {
    await tester.pumpWidget(const MaisonSucreeApp());
    await tester.pump();
  }

  testWidgets('Maison Sucrée app opens', (tester) async {
    await openApp(tester);

    expect(find.text('Collections'), findsWidgets);
    expect(find.text('Favourites'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('Collections screen displays search field', (tester) async {
    await openApp(tester);

    expect(
      find.widgetWithText(TextField, 'Find your sweet moment'),
      findsOneWidget,
    );
  });

  testWidgets('Collections screen displays category filters', (tester) async {
    await openApp(tester);

    expect(find.widgetWithText(ChoiceChip, 'All'), findsOneWidget);
    expect(
      find.widgetWithText(FilterChip, 'Show past batches'),
      findsOneWidget,
    );
  });

  testWidgets('Search displays empty state for unknown pastry', (tester) async {
    await openApp(tester);

    final searchField = find.widgetWithText(
      TextField,
      'Find your sweet moment',
    );

    await tester.enterText(searchField, 'zzzz_nonexistent_pastry_12345');

    await tester.pump();

    expect(find.text('No pastries match your search'), findsOneWidget);

    expect(find.text('Clear filters'), findsOneWidget);
  });

  testWidgets('Clear filters restores collection', (tester) async {
    await openApp(tester);

    final searchField = find.widgetWithText(
      TextField,
      'Find your sweet moment',
    );

    await tester.enterText(searchField, 'zzzz_nonexistent_pastry_12345');

    await tester.pump();

    expect(find.text('No pastries match your search'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pump();

    expect(find.text('No pastries match your search'), findsNothing);

    expect(find.widgetWithText(ChoiceChip, 'All'), findsOneWidget);
  });

  testWidgets('User can open Favourites tab', (tester) async {
    await openApp(tester);

    final favouritesTab = find.byWidgetPredicate(
      (widget) =>
          widget is NavigationDestination && widget.label == 'Favourites',
    );

    expect(favouritesTab, findsOneWidget);

    await tester.tap(favouritesTab);
    await tester.pump();

    expect(find.text('Favourites'), findsWidgets);
  });

  testWidgets('User can open Profile tab', (tester) async {
    await openApp(tester);

    final profileTab = find.byWidgetPredicate(
      (widget) => widget is NavigationDestination && widget.label == 'Profile',
    );

    expect(profileTab, findsOneWidget);

    await tester.tap(profileTab);
    await tester.pump();

    expect(find.text('Profile'), findsWidgets);
  });
}
