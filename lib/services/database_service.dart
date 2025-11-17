import 'package:path/path.dart';
import 'package:recipe_it/models/category_model.dart';
import 'package:recipe_it/models/category_recipe_model.dart';
import 'package:recipe_it/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _recipesTable = 'recipes';
  final String _recipesId = 'id';
  final String _recipesName = 'name';
  final String _recipesDescription = 'description';
  final String _recipesImage = 'image';
  final String _recipesIngredients = 'ingredients';
  final String _recipesSteps = 'steps';
  final String _recipesPrepTime = 'prepTime';
  final String _recipesCookTime = 'cookTime';
  final String _recipesTotalTime = 'totalTime';
  final String _recipesDifficulty = 'difficulty';
  final String _recipesRating = 'rating';
  final String _recipesIsFavorite = 'isFavorite';
  final String _recipesCategoryId = 'categoryId';

  final String _categoriesTable = 'categories';
  final String _categoriesId = 'id';
  final String _categoriesName = 'name';

  DatabaseService._constructor();

  Future<Database> get database async {
    _db ??= await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'recipe_it.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_categoriesTable (
            $_categoriesId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_categoriesName TEXT NOT NULL
          );
        ''');
        db.execute('''
          CREATE TABLE $_recipesTable (
            $_recipesId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_recipesName TEXT NOT NULL,
            $_recipesDescription TEXT,
            $_recipesImage TEXT,
            $_recipesIngredients TEXT NOT NULL,
            $_recipesSteps TEXT NOT NULL,
            $_recipesPrepTime INTEGER NOT NULL,
            $_recipesCookTime INTEGER NOT NULL,
            $_recipesTotalTime INTEGER NOT NULL,
            $_recipesDifficulty INTEGER NOT NULL,
            $_recipesRating INTEGER NOT NULL,
            $_recipesIsFavorite INTEGER NOT NULL,
            $_recipesCategoryId INTEGER,
            FOREIGN KEY($_recipesCategoryId) REFERENCES $_categoriesTable($_categoriesId)
              ON DELETE NO ACTION ON UPDATE NO ACTION
          );
        ''');
      },
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final Database db = await database;
    await db.insert(_recipesTable, recipe.toMap());
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final Database db = await database;
    await db.update(
      _recipesTable,
      recipe.toMap(),
      where: '$_recipesId = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> insertCategory(Category category) async {
    final Database db = await database;
    return await db.insert(_categoriesTable, category.toMap());
  }

  Future<List<CategoryRecipe>> getRecipes(bool getOnlyFavorites) async {
    final Database db = await database;
    final List<Map<String, dynamic>> recipesRaw = await db.rawQuery('''
      SELECT r.*, c.$_categoriesName AS categoryName
      FROM 
        $_recipesTable AS r
        LEFT OUTER JOIN $_categoriesTable AS c
        ON r.$_recipesCategoryId = c.$_categoriesId
      ${getOnlyFavorites ? 'WHERE r.$_recipesIsFavorite = 1' : ''}
      ORDER BY categoryName;
    ''');

    final List<CategoryRecipe> categories = [];
    for (final recipe in recipesRaw) {
      int categoryIndex = categories.indexWhere(
        (category) => category.categoryId == recipe['categoryId'],
      );
      if (categoryIndex == -1) {
        categories.add(
          CategoryRecipe(
            categoryId: recipe['categoryId'],
            categoryName: recipe['categoryName'],
            recipes: [Recipe.fromMap(recipe)],
          ),
        );
      } else {
        categories[categoryIndex].recipes.add(Recipe.fromMap(recipe));
      }
    }
    return categories;
  }

  Future<List<Category>> getAllCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> categories = await db.query(
      _categoriesTable,
      orderBy: _categoriesName,
    );
    return categories.map((e) => Category.fromMap(e)).toList();
  }

  void deleteCategory(int id) async {
    final Database db = await database;
    await db.update(
      _recipesTable,
      {_recipesCategoryId: null},
      where: '$_recipesCategoryId = ?',
      whereArgs: [id],
    );
    await db.delete(
      _categoriesTable,
      where: '$_categoriesId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> getRecipesByName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> recipesRaw = await db.rawQuery('''
      SELECT r.*
      FROM $_recipesTable AS r
      WHERE r.$_recipesName LIKE '%$name%'
    ''');

    return recipesRaw.map((e) => Recipe.fromMap(e)).toList();
  }

  Future<int> deleteRecipe(int id) async {
    final Database db = await database;
    return db.delete(_recipesTable, where: '$_recipesId = ?', whereArgs: [id]);
  }

  Future<void> favoriteRecipe(int id, bool isFavorite) async {
    final Database db = await database;
    await db.update(
      _recipesTable,
      {_recipesIsFavorite: isFavorite ? 1 : 0},
      where: '$_recipesId = ?',
      whereArgs: [id],
    );
  }
}
