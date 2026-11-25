import 'package:flutter/material.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Users API', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      );
}
