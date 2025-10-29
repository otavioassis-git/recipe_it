import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/pages/add_recipe/widgets/category_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/description_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/ingredients_section.dart';
import 'package:recipe_it/pages/add_recipe/widgets/name_section.dart';
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
  final List<int?> categoryIds = [];

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

    return Scaffold(
      appBar: AppBar(
        title: Text(text.add_new),
        centerTitle: true,
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
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
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FilledButton(onPressed: _createRecipe, child: Text('Create')),
        ),
      ),
    );
  }

  void _createRecipe() {
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

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(Icons.error),
              SizedBox(width: 4),
              Text('Name cannot be empty'),
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
              Text('Description cannot be empty'),
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
              Text('Ingredients cannot be empty'),
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
              Text('Steps cannot be empty'),
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
      ),
    );

    Navigator.pop(context);
    updateRecipesListNotifier.value = !updateRecipesListNotifier.value;
  }
}
