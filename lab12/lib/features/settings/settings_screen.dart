import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../users/users_model.dart';
import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();

    final users = context.watch<UsersModel>();

    final cities = users.items
        .map((user) => user.address.city)
        .where((city) => city.isNotEmpty)
        .toSet()
        .toList();

    final savedCity = settings.city;

    if (savedCity != null && !cities.contains(savedCity)) {
      cities.add(savedCity);
    }

    cities.sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Use dark appearance'),
            secondary: const Icon(Icons.dark_mode),
            value: settings.dark,
            onChanged: settings.setDark,
          ),

          const Divider(),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: settings.city ?? '',
            decoration: const InputDecoration(
              labelText: 'City filter',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text('All cities'),
              ),
              ...cities.map(
                (city) =>
                    DropdownMenuItem<String>(value: city, child: Text(city)),
              ),
            ],
            onChanged: (value) async {
              await settings.setCity(value == '' ? null : value);
            },
          ),

          const SizedBox(height: 24),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out'),
            onTap: () async {
              final auth = context.read<AuthModel>();

              Navigator.pop(context);

              await auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
