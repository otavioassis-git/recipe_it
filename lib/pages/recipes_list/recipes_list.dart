import 'package:flutter/material.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:recipe_it/services/database_service.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key});

  @override
  State<RecipesList> createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: databaseService.getAllCategorylessRecipes(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final recipes = snapshot.data as List<Recipe>;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              recipes[index].name,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              recipes[index].description,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          onPressed: () {},
                          iconSize: 18,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('No recipes found'));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
