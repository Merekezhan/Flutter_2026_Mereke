import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<Cart, int>((cart) => cart.count);
    // final count = context.watch<Cart>().count;

    debugPrint('badge build');

    return IconButton(
      icon: Badge(
        label: Text('$count'),
        child: const Icon(Icons.shopping_cart),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/cart');
      },
    );
  }
}