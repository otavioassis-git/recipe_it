import 'package:flutter/material.dart';
import 'package:recipe_it/models/category_model.dart';
import 'package:recipe_it/services/database_service.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key, required this.categoryIds});

  final List<int?> categoryIds;

  @override
  State<CategorySection> createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  final DatabaseService databaseService = DatabaseService.instance;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Text('Category'),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.all(0),
                    onPressed: () => showDialog(
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
                                'Info',
                                style: theme.textTheme.headlineSmall,
                              ),
                              Text(
                                'If you don\'t add a category, the recipe will be added to the "Uncategorized" category.',
                              ),
                              Text('You can add a category later.'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Close'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => showDialog(
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
                          'Add a category',
                          style: theme.textTheme.headlineSmall,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Category name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {
                                databaseService
                                    .insertCategory(
                                      Category(name: nameController.text),
                                    )
                                    .then((categoryId) {
                                      if (widget.categoryIds.isNotEmpty) {
                                        widget.categoryIds.removeAt(0);
                                      }
                                      widget.categoryIds.add(categoryId);
                                    });
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
            ),
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
                    isExpanded: true,
                    value: widget.categoryIds.isNotEmpty
                        ? widget.categoryIds[0]
                        : null,
                    selectedItemBuilder: (context) {
                      return [
                        DropdownMenuItem(
                          value: null,
                          child: Text('No category'),
                        ),
                        ...categories.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          );
                        }),
                      ];
                    },
                    items: [
                      DropdownMenuItem(value: null, child: Text('No category')),
                      ...categories.map((e) {
                        return DropdownMenuItem(
                          value: e.id,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.name),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 16,
                                          children: [
                                            Text(
                                              'Confirm deletion',
                                              style:
                                                  theme.textTheme.headlineSmall,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Are you sure you want to delete the ',
                                                  ),
                                                  TextSpan(
                                                    text: '${e.name}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(text: ' category?'),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'If there\'s any recipe associated with this category, it will be categorized under "Uncategorized".',
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Close'),
                                                ),
                                                SizedBox(width: 8),
                                                FilledButton(
                                                  onPressed: () {
                                                    databaseService
                                                        .deleteCategory(e.id!)
                                                        .then((categoryId) {
                                                          setState(() {
                                                            if (widget
                                                                    .categoryIds
                                                                    .isNotEmpty &&
                                                                widget.categoryIds[0] ==
                                                                    categoryId) {
                                                              widget.categoryIds
                                                                  .removeAt(0);
                                                            }
                                                          });
                                                        });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      }),
                    ].toList(),
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
