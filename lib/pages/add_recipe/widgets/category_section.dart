import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/category_model.dart';
import 'package:recipe_it/services/database_service.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

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
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    List<Category> categories = [];

    void addCategory() {
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
                  '${text.add} ${text.category}',
                  style: theme.textTheme.headlineSmall,
                ),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: text.smt_name(text.category),
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        nameController.text = '';
                      },
                      child: Text(text.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        databaseService
                            .insertCategory(Category(name: nameController.text))
                            .then((categoryId) {
                              if (widget.categoryIds.isNotEmpty) {
                                widget.categoryIds.removeAt(0);
                              }
                              widget.categoryIds.add(categoryId);
                              categories.add(
                                Category(
                                  id: categoryId,
                                  name: nameController.text,
                                ),
                              );
                            });
                        Navigator.pop(context);
                        setState(() {
                          nameController.text = '';
                        });
                      },
                      child: Text(text.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    void deleteCategory(Category category) {
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
                            .delition_confirmation(text.category.toLowerCase())
                            .split("typeName")[0],
                      ),
                      TextSpan(
                        text: category.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: text
                            .delition_confirmation(text.category.toLowerCase())
                            .split("typeName")[1],
                      ),
                    ],
                  ),
                ),
                Text(text.deletion_info),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(text.close),
                    ),
                    SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        databaseService.deleteCategory(category.id!);
                        setState(() {
                          categories.removeWhere(
                            (element) => element.id == category.id,
                          );
                          if (widget.categoryIds.isNotEmpty &&
                              widget.categoryIds[0] == category.id!) {
                            widget.categoryIds.clear();
                          }
                        });
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

    return CustomStickyHeaderContent(
      title: text.category,
      infoText: [text.category_info_1, text.category_info_2],
      showAction: true,
      actionFunction: addCategory,
      actionIcon: Icon(Icons.add),
      content: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: databaseService.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                categories = snapshot.data as List<Category>;
                return DropdownButton(
                  isExpanded: true,
                  value: widget.categoryIds.isNotEmpty
                      ? widget.categoryIds[0]
                      : null,
                  selectedItemBuilder: (context) {
                    return [
                      DropdownMenuItem(
                        value: null,
                        child: Text(text.no_category),
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
                    DropdownMenuItem(
                      value: null,
                      child: Text(text.no_category),
                    ),
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
                                deleteCategory(e);
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
                  child: Text(text.category_empty),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
