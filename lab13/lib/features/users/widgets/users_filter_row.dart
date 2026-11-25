import 'package:flutter/material.dart';

class UsersFilterRow extends StatelessWidget {
  const UsersFilterRow({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: const InputDecoration(labelText: 'Search users', prefixIcon: Icon(Icons.search)),
          onChanged: onChanged,
        ),
      );
}
