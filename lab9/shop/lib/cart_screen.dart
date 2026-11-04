
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'cart_badge.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool showTotal = true;

  Future<void> clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text(
            'Are you sure you want to remove all books?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      context.read<Cart>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.orange.shade100,
        actions: [
          const CartBadge(),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: clearCart,
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final book = cart.items[index];

                    return Card(
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text('${book.price} ₸'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('×${cart.qtyOf(book)}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cart.increment(book),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => cart.remove(book),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Order summary'),
                trailing: IconButton(
                  icon: Icon(
                    showTotal
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      showTotal = !showTotal;
                    });
                  },
                ),
              ),
              if (showTotal)
                Consumer<Cart>(
                  child: const _TotalLabel(),
                  builder: (context, currentCart, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          child!,
                          Text(
                            '${currentCart.total} ₸',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TotalLabel extends StatelessWidget {
  const _TotalLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.payments_outlined),
        SizedBox(width: 8),
        Text('Total:'),
      ],
    );
  }
}
