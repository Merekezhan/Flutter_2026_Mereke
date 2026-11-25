import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

void main() {
  final api = ApiClient();
  final UserRepository repo = HttpUserRepository(api);
  // For demo mode, replace the line above with a FakeUserRepository implementation.
  // final UserRepository repo = FakeUserRepository();
  final model = UsersModel(repo)..load();
  runApp(ChangeNotifierProvider.value(value: model, child: const Practice13App()));
}

class Practice13App extends StatelessWidget {
  const Practice13App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Practice 13',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const UsersScreen(),
      );
}
