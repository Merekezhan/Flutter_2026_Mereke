import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop/main.dart';
import 'package:shop/models/cart.dart';

void main() {
  testWidgets('Book Shop opens correctly', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()),
    );

    expect(find.text('Widgets All the Way Down'), findsOneWidget);
    expect(find.text('Null Safety for Humans'), findsOneWidget);
  });
}
