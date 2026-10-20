import 'package:flutter/material.dart';

import 'data/seed_data.dart';
import 'models/pastry.dart';
import 'models/profile.dart';
import 'routes.dart';
import 'screens/collections_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/pastry_form_screen.dart';

void main() {
  runApp(const MaisonSucreeApp());
}

class MaisonSucreeApp extends StatefulWidget {
  const MaisonSucreeApp({super.key});

  @override
  State<MaisonSucreeApp> createState() =>
      _MaisonSucreeAppState();
}

class _MaisonSucreeAppState extends State<MaisonSucreeApp> {
  ThemeMode _mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final light = ColorScheme.fromSeed(
      seedColor: const Color(0xFF823F55),
    );

    final dark = ColorScheme.fromSeed(
      seedColor: const Color(0xFFB87891),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Maison Sucrée',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: light,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: light.surface,
        ),
        scaffoldBackgroundColor: light.surface,
      ),
      darkTheme: ThemeData(
        colorScheme: dark,
        useMaterial3: true,
      ),
      themeMode: _mode,
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => ShellScreen(
              mode: _mode,
              onModeChanged: (value) {
                setState(() => _mode = value);
              },
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.form) {
          final original = settings.arguments is Pastry
              ? settings.arguments as Pastry
              : null;

          return MaterialPageRoute<Pastry>(
            settings: settings,
            builder: (_) => PastryFormScreen(
              original: original,
            ),
          );
        }

        return null;
      },
      onUnknownRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Not found'),
          ),
          body: const Center(
            child: Text('This page does not exist'),
          ),
        ),
      ),
    );
  }
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onModeChanged;

  @override
  State<ShellScreen> createState() =>
      _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  late List<Pastry> _items;

  Profile _profile = const Profile.empty();

  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _items = seedPastries();
  }

  Pastry? _current(String id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  void _replace(Pastry item) {
    setState(() {
      _items = [
        for (final old in _items)
          if (old.id == item.id) item else old,
      ];
    });
  }

  void _favourite(Pastry item) {
    final current = _current(item.id);

    if (current != null) {
      _replace(
        current.copyWith(
          isFavourite: !current.isFavourite,
        ),
      );
    }
  }

  void _reserve(Pastry item) {
    final current = _current(item.id);

    if (current == null ||
        _profile.name.trim().isEmpty) {
      return;
    }

    final name = _profile.name.trim();

    final names = current.contains(name)
        ? current.names
            .where((n) => n != name)
            .toList()
        : [...current.names, name];

    if (!current.contains(name) &&
        (current.isFull || current.isPast)) {
      return;
    }

    _replace(
      current.copyWith(names: names),
    );
  }

  Future<void> _edit(Pastry? original) async {
    final result = await Navigator.pushNamed<Pastry>(
      context,
      Routes.form,
      arguments: original,
    );

    if (!mounted || result == null) return;

    setState(() {
      if (original == null) {
        _items = [..._items, result];
      } else {
        _items = [
          for (final item in _items)
            if (item.id == result.id) result else item,
        ];
      }
    });
  }

  void _open(Pastry item) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => StatefulBuilder(
          builder: (context, refresh) {
            final current = _current(item.id);

            if (current == null) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(
                  child: Text('Batch deleted'),
                ),
              );
            }

            return DetailScreen(
              item: current,
              profileName: _profile.name,
              onReserve: (p) {
                _reserve(p);
                refresh(() {});
              },
              onEdit: (p) async {
                await _edit(p);

                if (context.mounted) {
                  refresh(() {});
                }
              },
              onDelete: (p) {
                setState(() {
                  _items = _items
                      .where((x) => x.id != p.id)
                      .toList();
                });
              },
              onOpenProfile: () {
                Navigator.pop(context);
                if (mounted) {
                  setState(() => _tab = 2);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _reset() async {
    Navigator.pop(context);

    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
          'Restore the sample batches and clear your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (!mounted || yes != true) return;

    setState(() {
      _items = seedPastries();
      _profile = const Profile.empty();
      _tab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Collections',
      'Favourites',
      'Profile',
    ];

    final favouritesCount =
        _items.where((p) => p.isFavourite).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tab]),
        actions: [
          IconButton(
            tooltip: 'Switch theme',
            icon: Icon(
              widget.mode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              widget.onModeChanged(
                widget.mode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'MAISON SUCRÉE\nFine Pâtisserie',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);

                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) =>
                        AlertDialog(
                      title: const Text('Maison Sucrée'),
                      content: const Text(
                        'A boutique pâtisserie demo for browsing '
                        'and reserving limited pastry batches.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset sample data'),
                onTap: _reset,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          CollectionsScreen(
            items: _items,
            onOpen: _open,
            onFavourite: _favourite,
            onCreate: () => _edit(null),
          ),
          FavouritesScreen(
            items: _items,
            onOpen: _open,
            onFavourite: _favourite,
            onExplore: () {
              setState(() => _tab = 0);
            },
          ),
          ProfileScreen(
            profile: _profile,
            items: _items,
            onSave: (profile) {
              setState(() => _profile = profile);
            },
          ),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => _edit(null),
              icon: const Icon(Icons.add),
              label: const Text('New batch'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          setState(() => _tab = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Collections',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$favouritesCount'),
              isLabelVisible: favouritesCount > 0,
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Favourites',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}