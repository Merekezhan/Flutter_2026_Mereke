// ignore_for_file: avoid_print
import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();

  library.open();

  final books = rawBooks.map(Book.fromJson).toList();

  for (final book in books) {
    library.add(book);
  }

  print('--- REPORT ---');
  print(library.buildReport());

  print('\n--- ALL TITLES ---');
  print(library.allTitles);

  print('\n--- BOOKS AFTER 2010 ---');
  print(library.booksAfter2010);

  print('\n--- AVERAGE PAGES ---');
  print(library.averagePages);

  print('\n--- BOOKS PER AUTHOR ---');
  print(library.booksPerAuthor);

  print('\n--- AUTHORS ---');
  print(library.authorNames);

  print('\n--- GENRES ---');
  print(library.genres);

  print('\n--- COUNTRY QUERY ---');
  print('Clean Code: ${library.countryOf('Clean Code')}');
  print('Design Patterns: ${library.countryOf('Design Patterns')}');

  print('\n--- DISPLAY LIST ---');
  print(library.displayList.join('\n'));

  final stats = statsOf(books);

  print('\n--- RECORD STATS ---');
  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n--- SHELF STATES ---');

  const empty = Empty();
  final ready = Ready(books);
  const broken = Broken('Catalogue unavailable');

  print(describe(empty));
  print(describe(ready));
  print(describe(broken));
}
