
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';
import 'cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(search.toLowerCase()) ||
          book.author.toLowerCase().contains(search.toLowerCase());
    }).toList();

    debugPrint('BooksScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: Colors.orange.shade100,
        actions: [
          const CartBadge(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];

                debugPrint('row ${book.title}');

                return _BookTile(book: book);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final added = context.select<Cart, bool>(
      (cart) => cart.qtyOf(book) > 0,
    );

    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} - ${book.price} ₸'),
      trailing: added
          ? const Text('Added')
          : OutlinedButton(
              onPressed: () {
                final success = context.read<Cart>().add(book);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${book.title} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
    );
  }
}
