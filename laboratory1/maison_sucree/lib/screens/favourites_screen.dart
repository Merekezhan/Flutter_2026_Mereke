import 'package:flutter/material.dart';

import '../models/pastry.dart';
import '../widgets/empty_state.dart';
import '../widgets/pastry_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onFavourite,
    required this.onExplore,
  });

  final List<Pastry> items;
  final ValueChanged<Pastry> onOpen;
  final ValueChanged<Pastry> onFavourite;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final favourites = items.where((p) => p.isFavourite).toList();

    if (favourites.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border,
        message: 'Your favourites will appear here',
        actionLabel: 'Explore collections',
        onAction: onExplore,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favourites.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final pastry = favourites[index];

        return PastryCard(
          pastry: pastry,
          onTap: () => onOpen(pastry),
          onFavourite: () => onFavourite(pastry),
        );
      },
    );
  }
}
