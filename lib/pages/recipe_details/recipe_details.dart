import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/recipe_details/widgets/details_section.dart';
import 'package:recipe_it/pages/recipe_details/widgets/scoring_timing_section.dart';
import 'package:recipe_it/services/database_service.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final bool newIsFavorite = widget.recipe.isFavorite == null
                  ? true
                  : !widget.recipe.isFavorite!;
              databaseService
                  .favoriteRecipe(widget.recipe.id!, newIsFavorite)
                  .then(
                    (_) => setState(() {
                      widget.recipe.isFavorite = newIsFavorite;
                    }),
                  );
            },
            icon: Icon(
              widget.recipe.isFavorite != null && widget.recipe.isFavorite!
                  ? Icons.favorite
                  : Icons.favorite_outline,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 4,
              children: [
                ScoringTimingSection(recipe: widget.recipe),
                DetailsSection(
                  title: text.description,
                  contents: [widget.recipe.description],
                ),
                DetailsSection(
                  title: text.ingredients,
                  contents: widget.recipe.ingredients.split(';'),
                ),
                DetailsSection(
                  title: text.steps,
                  contents: widget.recipe.steps.split(';'),
                  numering: true,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
