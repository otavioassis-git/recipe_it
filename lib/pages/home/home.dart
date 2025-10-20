import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/pages/create_archive/create_archive.dart';
import 'package:recipe_it/pages/settings/settings.dart';
import 'package:recipe_it/pages/widgets_tree/widgets_tree.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Recipe It',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  print("search button pressed");
                },
                icon: const Icon(Icons.search),
                tooltip: 'Search',
              ),
            ],
          ),
          body: WidgetsTree(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateArchive()),
            ),
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) {
              if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              } else {
                currentPageNotifier.value = value;
              }
            },
            selectedIndex: currentPage,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                label: 'Home',
                selectedIcon: const Icon(Icons.home),
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_border),
                label: 'Favorites',
                selectedIcon: const Icon(Icons.favorite),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
