import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/pages/recipes_list/recipes_list.dart';
import 'package:flutter/material.dart';

class WidgetsTree extends StatelessWidget {
  const WidgetsTree({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const RecipesList(),
      const Text("Favorites"),
    ];

    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: children[currentPage],
        );
      },
    );
  }
}
