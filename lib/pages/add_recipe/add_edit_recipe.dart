import 'package:flutter/material.dart';
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
import 'package:recipe_it/widgets/snackbars/error_snackbar.dart';

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
          ErrorSnackbar(text: text.empty_error(text.name)) as SnackBar,
        );
        return;
      }

      if (description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackbar(text: text.empty_error(text.description)) as SnackBar,
        );
        return;
      }

      if (ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackbar(text: text.empty_error(text.ingredients)) as SnackBar,
        );
        return;
      }

      if (steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackbar(text: text.empty_error(text.steps)) as SnackBar,
        );
        return;
      }

      if (prepTimeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackbar(text: text.empty_error(text.prep_time)) as SnackBar,
        );
        return;
      }

      if (cookTimeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackbar(text: text.empty_error(text.cook_time)) as SnackBar,
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
            isFavorite: widget.recipe!.isFavorite,
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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.isEdit ? text.edit : text.add} ${text.recipe}'),
        centerTitle: true,
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: NameSection(nameController: nameController),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DescriptionSection(
                          descriptionController: descriptionController,
                        ),
                        CategorySection(categoryIds: categoryIds),
                        IngredientsSection(
                          ingredientsControllers: ingredientsControllers,
                        ),
                        StepsSection(stepsControllers: stepsControllers),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            spacing: 4,
                            children: [
                              PrepTimeSection(
                                prepTimeController: prepTimeController,
                              ),
                              CookTimeSection(
                                cookTimeController: cookTimeController,
                              ),
                              RatingSection(rating: rating),
                            ],
                          ),
                        ),
                        SizedBox(height: 56),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 6.0,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: submitRecipe,
                  icon: Icon(widget.isEdit ? Icons.edit : Icons.add),
                  label: Text(widget.isEdit ? text.edit : text.create),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
