import 'package:flutter_test/flutter_test.dart';
import 'package:maison_sucree/main.dart';

void main() {
  testWidgets('Maison Sucrée app opens', (tester) async {
    await tester.pumpWidget(const MaisonSucreeApp());

    expect(find.text('Collections'), findsWidgets);
    expect(find.text('Favourites'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
