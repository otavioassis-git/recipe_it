import 'package:flutter/material.dart';
import 'package:recipe_it/models/recipe_model.dart';

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Text('Recipe'),
    );
  }
}
