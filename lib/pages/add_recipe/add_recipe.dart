import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/add_recipe/widgets/category_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/cook_time_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/description_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/rating_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/ingredients_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/name_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/prep_time_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/steps_section.dart';
import 'package:recipe_it/services/database_service.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final DatabaseService databaseService = DatabaseService.instance;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final List<TextEditingController> ingredientsControllers = [];
  final List<TextEditingController> stepsControllers = [];
  final TextEditingController prepTimeController = TextEditingController();
  final TextEditingController cookTimeController = TextEditingController();
  final List<int?> categoryIds = [];
  final List<double> rating = <double>[];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initControllers() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    ingredientsControllers.add(TextEditingController());
    stepsControllers.add(TextEditingController());
    rating.add(0);
    rating.add(0);
  }

  void _disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    for (final controller in ingredientsControllers) {
      controller.dispose();
    }
    for (final controller in stepsControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    void createRecipe() {
      final name = nameController.text;
      final description = descriptionController.text;
      final ingredients = ingredientsControllers
          .map((e) => e.text)
          .toList()
          .where((e) => e.isNotEmpty)
          .toList();
      final steps = stepsControllers
          .map((e) => e.text)
          .toList()
          .where((e) => e.isNotEmpty)
          .toList();
      final prepTime = int.tryParse(prepTimeController.text);
      final cookTime = int.tryParse(cookTimeController.text);
      final difficulty = rating[0];
      final score = rating[1];

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.name)),
              ],
            ),
          ),
        );
        return;
      }

      if (description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.description)),
              ],
            ),
          ),
        );
        return;
      }

      if (ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.ingredients)),
              ],
            ),
          ),
        );
        return;
      }

      if (steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.steps)),
              ],
            ),
          ),
        );
        return;
      }

      if (prepTimeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.prep_time)),
              ],
            ),
          ),
        );
        return;
      }

      if (cookTimeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.error),
                SizedBox(width: 4),
                Text(text.empty_error(text.cook_time)),
              ],
            ),
          ),
        );
        return;
      }

      databaseService.insertRecipe(
        Recipe(
          name: name,
          description: description,
          ingredients: ingredients.join(';'),
          steps: steps.join(';'),
          categoryId: categoryIds.isNotEmpty ? categoryIds[0] : null,
          prepTime: prepTime!,
          cookTime: cookTime!,
          totalTime: prepTime + cookTime,
          difficulty: difficulty,
          rating: score,
        ),
      );

      Navigator.pop(context);
      updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${text.add} ${text.recipe}'),
        centerTitle: true,
        leading: CloseButton(
          onPressed: () {
            Navigator.pop(context);
            updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameSection(nameController: nameController),
                DescriptionSection(
                  descriptionController: descriptionController,
                ),
                CategorySection(categoryIds: categoryIds),
                IngredientsSection(
                  ingredientsControllers: ingredientsControllers,
                ),
                StepsSection(stepsControllers: stepsControllers),
                PrepTimeSection(prepTimeController: prepTimeController),
                CookTimeSection(cookTimeController: cookTimeController),
                RatingSection(difficulty: rating),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FilledButton(
            onPressed: createRecipe,
            child: Text(text.create),
          ),
        ),
      ),
    );
  }
}
