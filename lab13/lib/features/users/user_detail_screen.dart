import 'package:flutter/material.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('User details')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
              Text('Email: ${user.email}'),
              Text('City: ${user.address.city}'),
              Text('Latitude: ${user.address.geo.lat}'),
            ],
          ),
        ),
      );
}
