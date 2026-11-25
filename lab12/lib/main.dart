import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'core/storage/secure_store.dart';

import 'features/auth/auth_model.dart';
import 'features/auth/login_screen.dart';

import 'features/settings/settings_model.dart';

import 'features/users/user_repository.dart';
import 'features/users/users_cache.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = SharedPreferencesAsync();

  final dark = await prefs.getBool('darkMode') ?? false;
  final city = await prefs.getString('cityFilter');

  final store = SecureStore();
  final token = await store.readToken();

  final client = http.Client();
  final api = ApiClient(client, store);
  final repo = UserRepository(api, UsersCache());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsModel(prefs, dark: dark, city: city),
        ),
        ChangeNotifierProvider(create: (_) => AuthModel(store, token)),
      ],
      child: App(repo: repo),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key, required this.repo});

  final UserRepository repo;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final auth = context.watch<AuthModel>();
    final signedIn = auth.signedIn;

    return ChangeNotifierProvider(
      key: ValueKey(signedIn),
      create: (_) {
        final model = UsersModel(repo);

        if (signedIn) {
          unawaited(model.load());
        }

        return model;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Practice 12 - Survive a Restart',

        themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),

        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),

        home: signedIn ? const UsersScreen() : const LoginScreen(),
      ),
    );
  }
}
