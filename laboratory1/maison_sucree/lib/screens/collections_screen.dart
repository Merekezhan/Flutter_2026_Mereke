import 'package:flutter/material.dart';

import '../models/pastry.dart';
import '../models/pastry_category.dart';
import '../widgets/empty_state.dart';
import '../widgets/pastry_card.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onFavourite,
    required this.onCreate,
  });

  final List<Pastry> items;
  final ValueChanged<Pastry> onOpen;
  final ValueChanged<Pastry> onFavourite;
  final VoidCallback onCreate;

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final _search = TextEditingController();

  PastryCategory? _category;
  bool _includePast = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _search.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();

    setState(() {
      _category = null;
      _includePast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.toLowerCase().trim();

    // where(): filter pastries by search, category, and date.
    final filtered = widget.items.where((pastry) {
      final matchesSearch =
          pastry.title.toLowerCase().contains(query) ||
          pastry.place.toLowerCase().contains(query);

      final matchesCategory = _category == null || pastry.category == _category;

      final matchesDate = _includePast || !pastry.isPast;

      return matchesSearch && matchesCategory && matchesDate;
    }).toList()..sort((a, b) => a.readyAt.compareTo(b.readyAt));

    // map(): extract titles of the currently visible pastries.
    final visibleTitles = filtered.map((pastry) => pastry.title).toList();

    // fold(): calculate total free places in visible batches.
    final totalFreePlaces = filtered.fold<int>(
      0,
      (total, pastry) => total + pastry.free,
    );

    // any(): check whether at least one visible batch is full.
    final hasFullBatch = filtered.any((pastry) => pastry.isFull);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Find your sweet moment',
              border: const OutlineInputBorder(),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearFilters,
                    ),
            ),
          ),
        ),

        SizedBox(
          height: 54,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _category == null,
                onSelected: (_) {
                  setState(() => _category = null);
                },
              ),
              const SizedBox(width: 8),
              for (final category in PastryCategory.values) ...[
                ChoiceChip(
                  label: Text(category.label),
                  selected: _category == category,
                  onSelected: (_) {
                    setState(() => _category = category);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilterChip(
              label: const Text('Show past batches'),
              selected: _includePast,
              onSelected: (value) {
                setState(() => _includePast = value);
              },
            ),
          ),
        ),

        // Collection statistics using map(), fold(), and any().
        if (filtered.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${visibleTitles.length} batches • '
                '$totalFreePlaces free places'
                '${hasFullBatch ? ' • Some batches are full' : ''}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),

        Expanded(
          child: filtered.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  message: 'No pastries match your search',
                  actionLabel: 'Clear filters',
                  onAction: _clearFilters,
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 600
                        ? (constraints.maxWidth / 300).floor().clamp(2, 4)
                        : 1;

                    if (columns == 1) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final pastry = filtered[index];

                          return PastryCard(
                            pastry: pastry,
                            onTap: () => widget.onOpen(pastry),
                            onFavourite: () => widget.onFavourite(pastry),
                          );
                        },
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 180,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final pastry = filtered[index];

                        return PastryCard(
                          pastry: pastry,
                          onTap: () => widget.onOpen(pastry),
                          onFavourite: () => widget.onFavourite(pastry),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
