import '../models/pastry.dart';
import '../models/pastry_category.dart';

List<Pastry> seedPastries() {
  final now = DateTime.now();

  final items = <(String, PastryCategory, int, int, String?, bool)>[
    (
      'Rose Raspberry Éclair',
      PastryCategory.eclairs,
      2,
      16,
      'Raspberry cream and rose glaze.',
      false,
    ),
    (
      'Pistachio Cloud Choux',
      PastryCategory.choux,
      3,
      12,
      'Roasted pistachio praline.',
      false,
    ),
    (
      'Vanilla Bean Macarons',
      PastryCategory.macarons,
      1,
      20,
      'Madagascar vanilla ganache.',
      true,
    ),
    (
      'Lemon Meringue Tartlet',
      PastryCategory.tartlets,
      4,
      10,
      'Bright citrus and toasted meringue.',
      false,
    ),
    (
      'Midnight Chocolate Gâteau',
      PastryCategory.cakes,
      5,
      8,
      'Dark chocolate layers.',
      false,
    ),
    (
      'Almond Butter Croissant',
      PastryCategory.viennoiseries,
      1,
      18,
      null,
      false,
    ),
    (
      'Strawberry Silk Éclair',
      PastryCategory.eclairs,
      6,
      14,
      'Fresh strawberry filling.',
      false,
    ),
    (
      'Salted Caramel Choux',
      PastryCategory.choux,
      2,
      10,
      'Caramel with a pinch of sea salt.',
      true,
    ),
    (
      'Lavender Honey Macarons',
      PastryCategory.macarons,
      3,
      24,
      'Floral honey cream.',
      false,
    ),
    (
      'Pear Frangipane Tartlet',
      PastryCategory.tartlets,
      -2,
      9,
      'Seasonal pear and almond.',
      false,
    ),
    (
      'Opera Coffee Cake',
      PastryCategory.cakes,
      7,
      6,
      'Coffee buttercream and ganache.',
      false,
    ),
    (
      'Pain au Chocolat',
      PastryCategory.viennoiseries,
      -1,
      15,
      'French butter pastry.',
      false,
    ),
  ];

  return [
    for (var i = 0; i < items.length; i++)
      Pastry(
        id: 'pastry-$i',
        title: items[i].$1,
        category: items[i].$2,
        readyAt: now.add(Duration(days: items[i].$3)),
        limit: items[i].$4,
        names: i == 0
            ? ['Camille', 'Lucie']
            : i == 4
            ? List.generate(8, (j) => 'Guest ${j + 1}')
            : i == 9
            ? ['Aline']
            : <String>[],
        isOnline: items[i].$6,
        place: items[i].$6
            ? 'https://maison-sucree.example/reserve'
            : 'Maison Sucrée, 12 Rue des Fleurs',
        description: items[i].$5,
        isFavourite: i == 1 || i == 7,
      ),
  ];
}
