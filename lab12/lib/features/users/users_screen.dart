import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';

import 'new_user_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    final settings = context.watch<SettingsModel>();

    final filteredItems = m.items.where((user) {
      return settings.city == null || user.address.city == settings.city;
    }).toList();

    Widget content;

    if (m.loading && m.items.isEmpty) {
      content = const LoadingView();
    } else {
      content = switch (m.error) {
        null => UserList(items: filteredItems),
        NoConnectionException() => Offline(onRetry: m.load),
        NotFoundException() || UnauthorizedException() => ErrorView(
          message: 'User not found or access denied',
          onRetry: m.load,
        ),
        ServerException(:final status) => ErrorView(
          message: 'Server error: $status',
          onRetry: m.load,
        ),
        BadResponseException() => ErrorView(
          message: 'Invalid server response',
          onRetry: m.load,
        ),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Server Users'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: m.loading ? null : m.load,
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (m.fromCache && m.error == null)
            MaterialBanner(
              leading: const Icon(Icons.wifi_off),
              content: const Text('Saved data · no connection · Retry'),
              actions: [
                TextButton(
                  onPressed: m.loading ? null : m.load,
                  child: const Text('Retry'),
                ),
              ],
            ),
          if (m.loading && m.items.isNotEmpty) const LinearProgressIndicator(),
          Expanded(child: content),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New user'),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.items});

  final List<User> items;

  @override
  Widget build(BuildContext context) {
    final m = context.read<UsersModel>();

    return RefreshIndicator(
      onRefresh: m.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final user = items[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                ),
              ),
              title: Text(user.name),
              subtitle: Text('${user.email}\n${user.address.city}'),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Offline extends StatelessWidget {
  const Offline({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      icon: Icons.wifi_off,
      message: 'No internet connection',
      onRetry: onRetry,
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  final String message;
  final Future<void> Function() onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
