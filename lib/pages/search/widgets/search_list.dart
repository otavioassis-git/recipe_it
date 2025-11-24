import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/widgets/recipe_card.dart';
import 'package:recipe_it/services/database_service.dart';

class SearchList extends StatefulWidget {
  const SearchList({super.key, required this.searchText});

  final String searchText;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    if (widget.searchText.isEmpty) {
      return Center(child: Text(text.search_somethign));
    }

    return ValueListenableBuilder(
      valueListenable: updateRecipesListNotifier,
      builder: (context, value, child) {
        return Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder(
            future: databaseService.getRecipesByName(widget.searchText),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final recipes = snapshot.data as List<Recipe>;
                return SingleChildScrollView(
                  child: Column(
                    spacing: 8,
                    children: [
                      SizedBox(height: 48),
                      ...recipes.map((recipe) {
                        return RecipeCard(recipe: recipe);
                      }),
                      SizedBox(height: 80),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text(text.search_empty));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
