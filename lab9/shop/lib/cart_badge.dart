import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    debugPrint('badge build');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$total ₸'),
        Badge(
          label: Text('$count'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
