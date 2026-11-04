import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  final Map<Book, int> _qty = {};

  List<Book> get items => List.unmodifiable(_qty.keys);

  int get count => _qty.length;

  int get total {
    int sum = 0;
    for (final entry in _qty.entries) {
      sum += entry.key.price * entry.value;
    }
    return sum;
  }

  int qtyOf(Book book) => _qty[book] ?? 0;

  bool add(Book book) {
    if (_qty.containsKey(book)) {
      return false;
    }

    _qty[book] = 1;
    notifyListeners();
    return true;
  }

  void increment(Book book) {
    if (!_qty.containsKey(book)) return;

    _qty[book] = _qty[book]! + 1;
    notifyListeners();
  }

  void remove(Book book) {
    if (_qty.remove(book) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_qty.isEmpty) return;

    _qty.clear();
    notifyListeners();
  }
}
