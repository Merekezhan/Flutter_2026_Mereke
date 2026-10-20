import 'dart:collection';

import 'pastry_category.dart';

class Pastry {
  final String id;
  final String title;
  final PastryCategory category;
  final DateTime readyAt;
  final int limit;
  final List<String> _names;
  final bool isOnline;
  final String place;
  final String? description;
  final bool isFavourite;

  const Pastry({
    required this.id,
    required this.title,
    required this.category,
    required this.readyAt,
    required this.limit,
    required List<String> names,
    required this.isOnline,
    required this.place,
    this.description,
    this.isFavourite = false,
    // ignore: prefer_initializing_formals
  }) : _names = names;

  Pastry.empty()
    : id = '',
      title = '',
      category = PastryCategory.eclairs,
      readyAt = DateTime.now(),
      limit = 1,
      _names = const [],
      isOnline = false,
      place = '',
      description = null,
      isFavourite = false;

  List<String> get names => UnmodifiableListView(_names);

  int get taken => _names.length;

  int get free => limit - taken;

  bool get isFull => free <= 0;

  bool get isPast => readyAt.isBefore(DateTime.now());

  bool contains(String name) => _names.contains(name);

  ({int taken, int free}) get places => (taken: taken, free: free);

  Pastry copyWith({
    String? id,
    String? title,
    PastryCategory? category,
    DateTime? readyAt,
    int? limit,
    List<String>? names,
    bool? isOnline,
    String? place,
    Object? description = _unchanged,
    bool? isFavourite,
  }) {
    return Pastry(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      readyAt: readyAt ?? this.readyAt,
      limit: limit ?? this.limit,
      names: List<String>.unmodifiable(names ?? _names),
      isOnline: isOnline ?? this.isOnline,
      place: place ?? this.place,
      description: identical(description, _unchanged)
          ? this.description
          : description as String?,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  static const Object _unchanged = Object();
}
