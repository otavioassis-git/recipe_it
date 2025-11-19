import 'package:flutter/material.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/widgets/recipe_card.dart';

class PaddedRecipeCard extends StatelessWidget {
  const PaddedRecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: RecipeCard(recipe: recipe),
    );
  }
}
