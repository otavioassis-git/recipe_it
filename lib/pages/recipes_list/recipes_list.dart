import 'package:flutter/material.dart';
import 'package:recipe_it/models/category_recipe_model.dart';
import 'package:recipe_it/models/recipe_model.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: databaseService.getAllUncategorizedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final [uncategorized, ...categories] =
                snapshot.data as List<CategoryRecipe>;
            final uncategorizedRecipes = uncategorized.recipes.map((recipe) {
              return RecipeCard(recipe: recipe);
            });
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
            return Column(
              spacing: 8,
              children: [
                ...uncategorizedRecipes,
                ExpansionPanelList(
                  elevation: 0,
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      panelExpansionControl[panelIndex] = isExpanded;
                      print(panelExpansionControl);
                    });
                  },
                  children: [...categorizedRecipes],
                ),
                const SizedBox(height: 16),
              ],
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(recipe.name, style: theme.textTheme.titleMedium),
                  Text(recipe.description, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(
              height: 24,
              width: 24,
              child: IconButton(
                onPressed: () {},
                iconSize: 18,
                padding: EdgeInsets.all(0),
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
