import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/pages/add_recipe/add_recipe.dart';
import 'package:recipe_it/pages/settings/settings.dart';
import 'package:recipe_it/pages/widgets_tree/widgets_tree.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

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
                tooltip: text.search,
              ),
            ],
          ),
          body: WidgetsTree(),
          floatingActionButton: FloatingActionButton(
            tooltip: text.add_new,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRecipe()),
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
                icon: const Icon(Icons.home),
                label: text.home,
                selectedIcon: const Icon(Icons.home),
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_border),
                label: text.favorites,
                selectedIcon: const Icon(Icons.favorite),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                label: text.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
