import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/add_recipe/add_edit_recipe.dart';
import 'package:recipe_it/pages/recipe_details/recipe_details.dart';
import 'package:recipe_it/services/database_service.dart';
import 'package:recipe_it/widgets/dialogs/delete_recipe.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final databaseService = DatabaseService.instance;

    deleteRecipe() async {
      final bool? deleteRecipe = await showDeleteRecipeDialog(
        context,
        widget.recipe.name,
      );

      if (deleteRecipe == true) {
        await databaseService.deleteRecipe(widget.recipe.id!);
        updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
      }
    }

    editRecipe() async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddEditRecipe(isEdit: true, recipe: widget.recipe),
        ),
      );
      updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
    }

    handleMenuSeleciton(String value) async {
      switch (value) {
        case 'edit':
          await editRecipe();
          break;
        case 'delete':
          deleteRecipe();
          break;
      }
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipe: widget.recipe),
          ),
        );
        updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
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
                    Text(
                      widget.recipe.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      widget.recipe.description,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: IconButton(
                  iconSize: 18,
                  padding: EdgeInsets.zero,
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
                    widget.recipe.isFavorite != null &&
                            widget.recipe.isFavorite!
                        ? Icons.favorite
                        : Icons.favorite_outline,
                  ),
                ),
              ),
              SizedBox(width: 4),
              SizedBox(
                height: 24,
                width: 24,
                child: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  onSelected: (value) => handleMenuSeleciton(value),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(text.edit),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(text.delete),
                        ),
                      ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
