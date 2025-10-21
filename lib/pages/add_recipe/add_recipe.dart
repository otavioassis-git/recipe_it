import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/category_model.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameSection(nameController: nameController),
                const SizedBox(height: 16),
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
      ),
    );

    Navigator.pop(context);
  }
}

class NameSection extends StatelessWidget {
  const NameSection({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: 'Recipe name',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  late FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => _onFocusChange());
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(() => _onFocusChange());
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Description'),
            isFocused
                ? IconButton(
                    onPressed: () => focusNode.unfocus(),
                    icon: Icon(Icons.check),
                  )
                : const SizedBox(height: 48),
          ],
        ),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: widget.descriptionController,
              maxLines: null,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Tell a little bit about the recipe...',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CategorySection extends StatefulWidget {
  const CategorySection({super.key, required this.categoryIds});

  final List<int?> categoryIds;

  @override
  State<CategorySection> createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: FutureBuilder(
              future: databaseService.getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final categories = snapshot.data as List<Category>;

                  return DropdownButton(
                    items: categories.map((e) {
                      return DropdownMenuItem(value: e.id, child: Text(e.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (widget.categoryIds.isNotEmpty) {
                          widget.categoryIds.clear();
                        }
                        widget.categoryIds.add(value);
                      });
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return SizedBox(
                    width: double.infinity,
                    child: Text('No categories registered'),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ],
    );
  }
}

class IngredientsSection extends StatefulWidget {
  const IngredientsSection({super.key, required this.ingredientsControllers});

  final List<TextEditingController> ingredientsControllers;

  @override
  State<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ingredients'),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.ingredientsControllers.add(TextEditingController());
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
                for (int i = 0; i < widget.ingredientsControllers.length; i++)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: widget.ingredientsControllers[i],
                        ),
                      ),
                      if (widget.ingredientsControllers.length > 1)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.ingredientsControllers.removeAt(i);
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
    );
  }
}

class StepsSection extends StatefulWidget {
  const StepsSection({super.key, required this.stepsControllers});

  final List<TextEditingController> stepsControllers;

  @override
  State<StepsSection> createState() => _StepsSectionState();
}

class _StepsSectionState extends State<StepsSection> {
  final List<FocusNode> focusNodes = [];
  final List<bool> isFocused = [];
  bool isKeyboardUp = false;

  @override
  void initState() {
    focusNodes.add(FocusNode());
    isFocused.add(false);
    focusNodes[0].addListener(() => _onFocusChange(0));
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].removeListener(() => _onFocusChange(i));
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _onFocusChange(int index) {
    setState(() {
      isFocused[index] = focusNodes[index].hasFocus;
      isKeyboardUp = isFocused.any((e) => e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Steps'),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.stepsControllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                  isFocused.add(false);
                  focusNodes[focusNodes.length - 1].addListener(
                    () => _onFocusChange(focusNodes.length - 1),
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
                for (int i = 0; i < widget.stepsControllers.length; i++)
                  Row(
                    children: [
                      Text('${i + 1}.', style: theme.textTheme.titleMedium),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          focusNode: focusNodes[i],
                          controller: widget.stepsControllers[i],
                          maxLines: null,
                        ),
                      ),
                      if (widget.stepsControllers.length > 1 || isKeyboardUp)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isFocused[i]) {
                                focusNodes[i].unfocus();
                              } else {
                                widget.stepsControllers.removeAt(i);
                                focusNodes[i].removeListener(
                                  () => _onFocusChange(i),
                                );
                                focusNodes[i].dispose();
                                focusNodes.removeAt(i);
                                isFocused.removeAt(i);
                              }
                            });
                          },
                          icon: Icon(isFocused[i] ? Icons.check : Icons.delete),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
