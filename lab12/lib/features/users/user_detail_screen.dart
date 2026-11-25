import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    bool success;

    try {
      success = await launchUrl(uri);
    } catch (_) {
      success = false;
    }

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  Future<void> _copyToken(BuildContext context) async {
    final token = await SecureStore().readToken();

    if (token == null) return;

    await Clipboard.setData(ClipboardData(text: token));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Token copied')));
  }

  @override
  Widget build(BuildContext context) {
    final website = user.website;

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

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(user.email),
            onTap: () async {
              await _open(context, Uri(scheme: 'mailto', path: user.email));
            },
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () async {
              await _open(context, Uri(scheme: 'tel', path: user.phoneDigits));
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(website ?? 'Not provided'),
            onTap: website == null || website.isEmpty
                ? null
                : () async {
                    final url = website.startsWith('https://')
                        ? website
                        : 'https://$website';

                    await _open(context, Uri.parse(url));
                  },
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

          if (kDebugMode)
            OutlinedButton.icon(
              onPressed: () async {
                await _copyToken(context);
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy token to clipboard'),
            ),
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
