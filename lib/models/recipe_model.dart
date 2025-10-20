class Recipe {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String ingredients;
  final String steps;
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final String difficulty;
  final int rating;
  final bool isFavorite;
  final int categoryId;

  Recipe({
    this.id,
    required this.name,
    this.description = '',
    this.image = '',
    this.ingredients = '',
    this.steps = '',
    this.prepTime = 0,
    this.cookTime = 0,
    this.totalTime = 0,
    this.difficulty = '',
    this.rating = 0,
    this.isFavorite = false,
    this.categoryId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      'steps': steps,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'difficulty': difficulty,
      'rating': rating,
      'isFavorite': isFavorite ? 1 : 0,
      'categoryId': categoryId,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      ingredients: map['ingredients'] as String,
      steps: map['steps'] as String,
      prepTime: map['prepTime'] as int,
      cookTime: map['cookTime'] as int,
      totalTime: map['totalTime'] as int,
      difficulty: map['difficulty'] as String,
      rating: map['rating'] as int,
      isFavorite: map['isFavorite'] as bool,
      categoryId: map['categoryId'] as int,
    );
  }
}
