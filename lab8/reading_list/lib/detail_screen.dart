import 'package:flutter/material.dart';
import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});
  final Book book;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        content: const Text('This book will be removed from your reading list.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed == true) Navigator.pop(context, BookAction.delete);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Book details')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Author: ${book.author}'),
              Text('Pages: ${book.pages}'),
              Text(book.year == null ? 'Year unknown' : 'Year: ${book.year}'),
              Text('Status: ${book.read ? 'Read' : 'Unread'}'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context, BookAction.toggleRead),
                child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
              ),
              OutlinedButton(onPressed: () => _confirmDelete(context), child: const Text('Delete')),
            ],
          ),
        ),
      );
}
