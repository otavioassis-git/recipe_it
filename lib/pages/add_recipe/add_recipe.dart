import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';
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
    final theme = Theme.of(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Recipe name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('Description'),
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Tell a little bit about the recipe...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ingredients'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              ingredientsControllers.add(
                                TextEditingController(),
                              );
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          spacing: 4,
                          children: [
                            for (
                              int i = 0;
                              i < ingredientsControllers.length;
                              i++
                            )
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: ingredientsControllers[i],
                                      maxLines: null,
                                    ),
                                  ),
                                  if (ingredientsControllers.length > 1)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          ingredientsControllers.removeAt(i);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Steps'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              stepsControllers.add(TextEditingController());
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          spacing: 4,
                          children: [
                            for (int i = 0; i < stepsControllers.length; i++)
                              Row(
                                children: [
                                  Text(
                                    '${i + 1}.',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: stepsControllers[i],
                                      maxLines: null,
                                    ),
                                  ),
                                  if (stepsControllers.length > 1)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          stepsControllers.removeAt(i);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
      ),
    );

    Navigator.pop(context);
  }
}
