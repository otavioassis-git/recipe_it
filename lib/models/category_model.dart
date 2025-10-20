import 'package:recipe_it/models/recipe_model.dart';

class Category {
  final int id;
  final String name;
  final List<Recipe> recipes = [];

  Category({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'] as int, name: map['name'] as String);
  }
}
