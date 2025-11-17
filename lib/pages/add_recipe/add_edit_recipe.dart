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

class AddEditRecipe extends StatefulWidget {
  const AddEditRecipe({super.key, this.isEdit = false, this.recipe});

  final bool isEdit;
  final Recipe? recipe;

  @override
  State<AddEditRecipe> createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
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
    nameController = TextEditingController(text: widget.recipe?.name);
    descriptionController = TextEditingController(
      text: widget.recipe?.description,
    );
    if (!widget.isEdit) {
      ingredientsControllers.add(TextEditingController());
      stepsControllers.add(TextEditingController());
    } else {
      List<String> ingredients = widget.recipe!.ingredients.split(';');
      List<String> steps = widget.recipe!.steps.split(';');
      for (String ingredient in ingredients) {
        ingredientsControllers.add(TextEditingController(text: ingredient));
      }
      for (String step in steps) {
        stepsControllers.add(TextEditingController(text: step));
      }
      prepTimeController.text = widget.recipe!.prepTime.toString();
      cookTimeController.text = widget.recipe!.cookTime.toString();
      categoryIds.add(widget.recipe!.categoryId);
      rating.add(widget.recipe!.difficulty);
      rating.add(widget.recipe!.rating);
    }
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

    void submitRecipe() async {
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

      if (widget.isEdit) {
        await databaseService.updateRecipe(
          Recipe(
            id: widget.recipe!.id,
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
      } else {
        await databaseService.insertRecipe(
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
      }

      Navigator.pop(context);
      updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.isEdit ? text.edit : text.add} ${text.recipe}'),
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
                RatingSection(rating: rating),
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
            onPressed: submitRecipe,
            child: Text(widget.isEdit ? text.edit : text.create),
          ),
        ),
      ),
    );
  }
}
