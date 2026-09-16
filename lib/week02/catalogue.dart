import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;
  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  String buildReport() =>
      _cachedReport ??= items.map((item) => item.describe()).join('\n');

  // LEVEL 4

  List<String> get allTitles =>
      items.map((item) => item.title).toList();

  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  // fold is preferred over reduce because it has an initial value
  // and can therefore work safely with an empty collection.
  double get averagePages =>
      items.whereType<Book>().isEmpty
          ? 0
          : items.whereType<Book>().fold<int>(
                  0,
                  (sum, book) => sum + book.pages,
                ) /
                items.whereType<Book>().length;

  Map<String, int> get booksPerAuthor =>
      items.whereType<Book>().fold<Map<String, int>>(
        {},
        (map, book) => {
          ...map,
          book.author.name: (map[book.author.name] ?? 0) + 1,
        },
      );

  Set<String> get authorNames =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  Set<Genre> get genres =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  List<String> get displayList => [
        'CATALOGUE',
        for (final book in items.whereType<Book>())
          '${book.title} (${book.year})',
        ...authorNames,
        if (items.whereType<Book>().any((book) => book.pages == 0))
          '(incomplete data)',
      ];
}