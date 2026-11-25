import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practice13/features/users/users_model.dart';
import 'package:practice13/features/users/users_screen.dart';
import '../../fakes/fake_user_repository.dart';

void main() {
  testWidgets('shows offline view and Retry loading spinner', (tester) async {
    final model = UsersModel(FakeUserRepository(fail: true, delay: const Duration(seconds: 2)));
    await model.load();
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider.value(value: model, child: const UsersScreen()),
    ));
    expect(find.text('No connection'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    model.dispose();
  });
}
