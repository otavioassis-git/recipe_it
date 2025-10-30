class Recipe {
  final int? id;
  final String name;
  final String description;
  final String? image;
  final String ingredients;
  final String steps;
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final double difficulty;
  final double rating;
  bool? isFavorite;
  final int? categoryId;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    this.image,
    required this.ingredients,
    required this.steps,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.difficulty,
    required this.rating,
    this.isFavorite,
    this.categoryId,
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
      'isFavorite': isFavorite == null ? 0 : (isFavorite! ? 1 : 0),
      'categoryId': categoryId,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      ingredients: map['ingredients'],
      steps: map['steps'],
      prepTime: map['prepTime'],
      cookTime: map['cookTime'],
      totalTime: map['totalTime'],
      difficulty: map['difficulty'].toDouble(),
      rating: map['rating'].toDouble(),
      isFavorite: map['isFavorite'] == 1,
      categoryId: map['categoryId'],
    );
  }
}
