import 'package:flutter/material.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/recipe_details/recipe_details.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipe: recipe),
          ),
        );
      },
      child: Card(
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
      ),
    );
  }
}
