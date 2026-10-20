import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/pastry.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.items,
    required this.onSave,
  });

  final Profile profile;
  final List<Pastry> items;
  final ValueChanged<Profile> onSave;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _group;

  @override
  void initState() {
    super.initState();

    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.profile.name != widget.profile.name &&
        _name.text != widget.profile.name) {
      _name.text = widget.profile.name;
    }

    if (oldWidget.profile.group != widget.profile.group &&
        _group.text != widget.profile.group) {
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  void _save() {
    final group = _group.text.trim();

    if (group.isNotEmpty && !RegExp(r'^[a-zA-Z0-9 -]{2,20}$').hasMatch(group)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group: 2–20 letters, numbers, spaces or hyphens'),
        ),
      );
      return;
    }

    widget.onSave(Profile(name: _name.text.trim(), group: group));

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    final registered = widget.profile.name.trim().isEmpty
        ? 0
        : widget.items.where((p) => p.contains(widget.profile.name)).length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(
          Icons.account_circle_outlined,
          size: 84,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Your pâtisserie profile',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _save(),
          decoration: const InputDecoration(
            labelText: 'Your name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _group,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
          decoration: const InputDecoration(
            labelText: 'Group (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(onPressed: _save, child: const Text('Save profile')),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'You are on $registered lists',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
