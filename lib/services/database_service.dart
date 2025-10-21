import 'package:path/path.dart';
import 'package:recipe_it/models/category_model.dart';
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
            $_recipesPrepTime INTEGER,
            $_recipesCookTime INTEGER,
            $_recipesTotalTime INTEGER,
            $_recipesDifficulty TEXT,
            $_recipesRating INTEGER,
            $_recipesIsFavorite INTEGER,
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

  Future<void> insertCategory(Category category) async {
    final Database db = await database;
    await db.insert(_categoriesTable, category.toMap());
  }

  Future<List<Recipe>> getAllCategorylessRecipes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> recipes = await db.query(
      _recipesTable,
      where: '$_recipesCategoryId IS NULL',
      orderBy: _recipesName,
    );
    return recipes.map((e) => Recipe.fromMap(e)).toList();
  }

  Future<List<Category>> getAllCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> categories = await db.query(
      _categoriesTable,
      orderBy: _categoriesName,
    );
    print(categories);
    return categories.map((e) => Category.fromMap(e)).toList();
  }
}
