import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'core/api/api_exception.dart';
import 'features/users/user.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = http.Client();
  final api = ApiClient(client);
  final repo = UserRepository(api);

  // Level 2: test real JSON before runApp.
  const rawUser = r'''
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  }
  ''';

  final parsed = User.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);

  debugPrint('Parsed user: $parsed');
  debugPrint('Round-trip: ${User.fromJson(parsed.toJson()) == parsed}');

  // Level 3: repository verification.
  if (kDebugMode) {
    try {
      final users = await repo.getAll();
      for (final user in users) {
        debugPrint('User: ${user.name}');
      }

      try {
        await repo.getById(999);
      } on NotFoundException {
        debugPrint('not found');
      }

      final created = await repo.create(parsed);
      debugPrint('Created user id: ${created.id}');
    } on ApiException catch (e) {
      debugPrint('Repository test error: $e');
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => UsersModel(repo)..load(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practice 11 - Real Server',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const UsersScreen(),
    );
  }
}
