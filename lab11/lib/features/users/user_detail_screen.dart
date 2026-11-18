import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          info('ID', '${user.id}'),
          info('Name', user.name),
          info('Username', user.username),
          info('Email', user.email),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'Not provided'),
            onTap: () {},
          ),
          const Divider(),
          info('Street', user.address.street),
          info('Suite', user.address.suite),
          info('City', user.address.city),
          info('Zipcode', user.address.zipcode),
          info('Latitude', '${user.address.geo.lat}'),
          info('Longitude', '${user.address.geo.lng}'),
          const Divider(),
          info('Company', user.company.name),
          info('Catch phrase', user.company.catchPhrase),
        ],
      ),
    );
  }

  Widget info(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value.isEmpty ? 'Not provided' : value),
    );
  }
}
