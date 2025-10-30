import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/recipe_details/recipe_details.dart';
import 'package:recipe_it/services/database_service.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

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
                        text: recipe.name,
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
                            .deleteRecipe(recipe.id!)
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

    handleMenuSeleciton(String value) {
      switch (value) {
        case 'favorite':
          break;
        case 'edit':
          break;
        case 'delete':
          deleteRecipe();
          break;
      }
    }

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
                child: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  onSelected: (value) => handleMenuSeleciton(value),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'favorite',
                          child: Text('Favorite'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
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
