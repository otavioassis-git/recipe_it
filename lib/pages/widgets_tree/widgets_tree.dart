import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/pages/recipes_list/recipes_list.dart';
import 'package:flutter/material.dart';

class WidgetsTree extends StatelessWidget {
  const WidgetsTree({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: AnimatedCrossFade(
            firstChild: RecipesList(),
            secondChild: Text('Favorites'),
            crossFadeState: currentPage == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 150),
          ),
        );
      },
    );
  }
}
