import 'package:flutter/material.dart';

enum PastryCategory {
  eclairs('Éclairs', Icons.bakery_dining),
  choux('Choux', Icons.cake),
  macarons('Macarons', Icons.cookie),
  tartlets('Tartlets', Icons.pie_chart),
  cakes('Cakes', Icons.cake_outlined),
  viennoiseries('Viennoiseries', Icons.breakfast_dining);

  const PastryCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    PastryCategory.eclairs => scheme.primary,
    PastryCategory.choux => scheme.secondary,
    PastryCategory.macarons => scheme.tertiary,
    PastryCategory.tartlets => scheme.primaryContainer,
    PastryCategory.cakes => scheme.secondaryContainer,
    PastryCategory.viennoiseries => scheme.tertiaryContainer,
  };

  String get imagePath => switch (this) {
    PastryCategory.eclairs => 'assets/images/eclair.jpg',
    PastryCategory.choux => 'assets/images/choux.jpg',
    PastryCategory.macarons => 'assets/images/macaron.jpg',
    PastryCategory.tartlets => 'assets/images/tartlet.jpg',
    PastryCategory.cakes => 'assets/images/cake.jpg',
    PastryCategory.viennoiseries => 'assets/images/viennoiserie.jpg',
  };
}
