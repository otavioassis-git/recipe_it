import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/add_recipe/add_edit_recipe.dart';
import 'package:recipe_it/pages/recipe_details/recipe_details.dart';
import 'package:recipe_it/services/database_service.dart';

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

    deleteRecipe() {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  text.confirm_deletion_title,
                  style: theme.textTheme.headlineSmall,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: text
                            .delition_confirmation(text.recipe.toLowerCase())
                            .split("typeName")[0],
                      ),
                      TextSpan(
                        text: widget.recipe.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: text
                            .delition_confirmation(text.recipe.toLowerCase())
                            .split("typeName")[1],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(text.close),
                    ),
                    SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        databaseService
                            .deleteRecipe(widget.recipe.id!)
                            .then(
                              (_) => updateRecipesListNotifier.value =
                                  !updateRecipesListNotifier.value,
                            );
                        Navigator.pop(context);
                      },
                      child: Text(text.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
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
