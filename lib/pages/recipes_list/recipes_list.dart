import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/models/category_recipe_model.dart';
import 'package:recipe_it/pages/recipes_list/widgets/recipe_card.dart';
import 'package:recipe_it/services/database_service.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key});

  @override
  State<RecipesList> createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final DatabaseService databaseService = DatabaseService.instance;

  final List<bool> panelExpansionControl = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: updateRecipesListNotifier,
      builder: (context, value, child) => FutureBuilder(
        future: databaseService.getAllUncategorizedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final categories = snapshot.data as List<CategoryRecipe>;
            List<Widget> uncategorizedRecipes = [];
            if (categories[0].categoryId == null) {
              uncategorizedRecipes = categories[0].recipes.map((recipe) {
                return RecipeCard(recipe: recipe);
              }).toList();
              categories.removeAt(0);
            }
            if (panelExpansionControl.isEmpty) {
              panelExpansionControl.addAll(
                List.filled(categories.length, true, growable: false),
              );
            }
            int index = -1;
            final categorizedRecipes = categories.map((category) {
              index++;
              return ExpansionPanel(
                isExpanded: panelExpansionControl[index],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return ListTile(title: Text(category.categoryName!));
                },
                body: Column(
                  spacing: 8,
                  children: category.recipes.map((recipe) {
                    return RecipeCard(recipe: recipe);
                  }).toList(),
                ),
              );
            });
            return SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  ...uncategorizedRecipes,
                  ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        panelExpansionControl[panelIndex] = isExpanded;
                      });
                    },
                    children: [...categorizedRecipes],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
