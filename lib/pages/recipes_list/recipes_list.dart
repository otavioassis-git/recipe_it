import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/widgets/dialogs/add_edit_category.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/category_model.dart';
import 'package:recipe_it/models/category_recipe_model.dart';
import 'package:recipe_it/pages/recipes_list/widgets/padded_recipe_card.dart';
import 'package:recipe_it/services/database_service.dart';
import 'package:recipe_it/widgets/dialogs/delete_category.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key, required this.isOnlyFavorites});

  final bool isOnlyFavorites;

  @override
  State<RecipesList> createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final DatabaseService databaseService = DatabaseService.instance;

  List<Widget> buildUncategorizedRecipes(
    List<CategoryRecipe> categoriesRecipes,
  ) {
    List<Widget> uncategorizedRecipes = [];
    int uncategorizedIndex = categoriesRecipes.indexWhere(
      (element) => element.categoryId == null,
    );
    if (uncategorizedIndex >= 0) {
      uncategorizedRecipes = categoriesRecipes[uncategorizedIndex].recipes.map((
        recipe,
      ) {
        return PaddedRecipeCard(recipe: recipe);
      }).toList();
      categoriesRecipes.removeWhere((element) => element.categoryId == null);
    }
    return uncategorizedRecipes;
  }

  List<Widget> buildCategorizedRecipes(List<CategoryRecipe> categoriesRecipes) {
    final text = AppLocalizations.of(context)!;

    void editCategory(Category category) async {
      final String? newCategoryName = await showAddEditCategoryDialog(
        context,
        true,
        category.name,
      );

      if (newCategoryName != null) {
        await databaseService.updateCategory(
          Category(id: category.id, name: newCategoryName),
        );
        updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
      }
    }

    void deleteCategory(Category category) async {
      final bool? deleteCategory = await showDeleteCategoryDialog(
        context,
        category.name,
      );

      if (deleteCategory == true) {
        await databaseService.deleteCategory(category.id!);
        updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
      }
    }

    handleCategoryMenuSeleciton(String value) {
      final valueSplit = value.split('-');
      final type = valueSplit[0];
      final categoryId = int.parse(valueSplit[1]);
      final categoryName = valueSplit[2];
      final category = Category(id: categoryId, name: categoryName);

      switch (type) {
        case 'edit':
          editCategory(category);
          break;
        case 'delete':
          deleteCategory(category);
          break;
      }
    }

    return categoriesRecipes.map((category) {
      return ExpansionTile(
        clipBehavior: Clip.none,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(category.categoryName!),
        initiallyExpanded: categoriesRecipes.length <= 5,
        trailing: SizedBox(
          height: 24,
          width: 24,
          child: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            iconSize: 18,
            padding: EdgeInsets.zero,
            onSelected: (value) => handleCategoryMenuSeleciton(value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit-${category.categoryId}-${category.categoryName}',
                child: Text(text.edit),
              ),
              PopupMenuItem<String>(
                value: 'delete-${category.categoryId}-${category.categoryName}',
                child: Text(text.delete),
              ),
            ],
          ),
        ),
        children: [
          Column(
            spacing: 8.0,
            children: [
              SizedBox(),
              ...category.recipes.map((recipe) {
                return PaddedRecipeCard(recipe: recipe);
              }),
            ],
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return ValueListenableBuilder(
      valueListenable: updateRecipesListNotifier,
      builder: (context, value, child) => FutureBuilder(
        future: databaseService.getRecipes(widget.isOnlyFavorites),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final categories = snapshot.data as List<CategoryRecipe>;

            List<Widget> uncategorizedRecipes = buildUncategorizedRecipes(
              categories,
            );

            List<Widget> categorizedRecipes = buildCategorizedRecipes(
              categories,
            );

            return SingleChildScrollView(
              child: Column(
                spacing: 6.0,
                children: [
                  ...uncategorizedRecipes,
                  ...categorizedRecipes,
                  const SizedBox(height: 16),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                widget.isOnlyFavorites
                    ? text.favorite_empty
                    : text.recipe_empty,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
