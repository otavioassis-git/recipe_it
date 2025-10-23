import 'package:recipe_it/models/recipe_model.dart';

class CategoryRecipe {
  final int? categoryId;
  final String? categoryName;
  final List<Recipe> recipes;

  CategoryRecipe({this.categoryId, this.categoryName, required this.recipes});
}
