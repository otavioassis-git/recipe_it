import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/category_recipe_model.dart';
import 'package:recipe_it/pages/recipes_list/widgets/recipe_card.dart';
import 'package:recipe_it/services/database_service.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key, required this.isOnlyFavorites});

  final bool isOnlyFavorites;

  @override
  State<RecipesList> createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return ValueListenableBuilder(
      valueListenable: updateRecipesListNotifier,
      builder: (context, value, child) => FutureBuilder(
        future: databaseService.getRecipes(widget.isOnlyFavorites),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final categories = snapshot.data as List<CategoryRecipe>;

            List<Widget> uncategorizedRecipes = [];
            if (categories[0].categoryId == null) {
              uncategorizedRecipes = categories[0].recipes.map((recipe) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 2.0,
                  ),
                  child: RecipeCard(recipe: recipe),
                );
              }).toList();
              categories.removeAt(0);
            }

            final categorizedRecipes = categories.map((category) {
              return ExpansionTile(
                clipBehavior: Clip.none,
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                collapsedShape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                title: Text(category.categoryName!),
                initiallyExpanded: categories.length <= 5,
                children: [
                  Column(
                    spacing: 8,
                    children: [
                      SizedBox(),
                      ...category.recipes.map((recipe) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 2.0,
                          ),
                          child: RecipeCard(recipe: recipe),
                        );
                      }),
                    ],
                  ),
                ],
              );
            });
            return SingleChildScrollView(
              child: Column(
                spacing: 6,
                children: [
                  ...uncategorizedRecipes,
                  ...categorizedRecipes,
                  const SizedBox(height: 16),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                widget.isOnlyFavorites
                    ? text.favorite_empty
                    : text.recipe_empty,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
