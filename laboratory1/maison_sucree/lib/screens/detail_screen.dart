import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pastry.dart';
import '../models/countdown.dart';
import '../utils/format.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.item,
    required this.profileName,
    required this.onReserve,
    required this.onEdit,
    required this.onDelete,
    required this.onOpenProfile,
  });
  final Pastry item;
  final String profileName;
  final ValueChanged<Pastry> onReserve;
  final ValueChanged<Pastry> onEdit;
  final ValueChanged<Pastry> onDelete;
  final VoidCallback onOpenProfile;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _reserve() async {
    if (widget.profileName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add your name in Profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: widget.onOpenProfile,
          ),
        ),
      );
      return;
    }
    final registered = widget.item.contains(widget.profileName);
    if (!registered && (widget.item.isFull || widget.item.isPast)) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(registered ? 'Cancel reservation?' : 'Reserve a pastry?'),
        content: Text(
          registered
              ? 'Remove your name from this batch?'
              : 'Reserve one portion of ${widget.item.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (!mounted || yes != true) return;
    widget.onReserve(widget.item);
  }

  Future<void> _delete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this batch?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || yes != true) return;
    widget.onDelete(widget.item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final registered = item.contains(widget.profileName);
    final scheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maison Sucrée'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (action) {
                if (action == 'edit') widget.onEdit(item);
                if (action == 'delete') _delete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  item.category.imagePath,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 220,
                    color: item.category.color(scheme).withValues(alpha: 0.16),
                    child: Icon(
                      item.category.icon,
                      size: 100,
                      color: scheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Chip(label: Text(item.category.label)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(formatDate(item.readyAt)),
                  Text(
                    countdownText(countdownFor(item.readyAt, _now)),
                    style: TextStyle(color: scheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.taken} reserved · ${item.free} available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'About'),
                Tab(text: 'Guest list'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (item.description case final description?) ...[
                        Text(description),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        item.isOnline
                            ? 'Online reservation'
                            : 'Pickup location',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SelectableText(item.place),
                    ],
                  ),
                  item.names.isEmpty
                      ? const Center(child: Text('No reservations yet'))
                      : ListView.builder(
                          itemCount: item.names.length,
                          itemBuilder: (context, index) {
                            final name = item.names[index];
                            return ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontWeight: name == widget.profileName
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: name == widget.profileName
                                  ? const Text('You')
                                  : null,
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton(
              onPressed: (registered || (!item.isFull && !item.isPast))
                  ? _reserve
                  : null,
              child: Text(
                registered
                    ? 'Cancel reservation'
                    : item.isFull
                    ? 'Fully booked'
                    : item.isPast
                    ? 'Batch ended'
                    : 'Reserve one pastry',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
