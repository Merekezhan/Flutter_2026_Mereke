
import 'package:flutter/material.dart';
import 'main.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.items,
    required this.onRemove,
  });

  final List<Book> items;
  final void Function(Book) onRemove;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(0, (sum, b) => sum + b.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: items.map((b) {
                return ListTile(
                  title: Text(b.title),
                  subtitle: Text('${b.price} ₸'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => onRemove(b),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Total: $total ₸'),
          ),
        ],
      ),
    );
  }
}
