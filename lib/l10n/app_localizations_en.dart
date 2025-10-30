// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get home => 'Recipes';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get system => 'System';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get search => 'Search';

  @override
  String get add => 'Add';

  @override
  String get recipe => 'Recipe';

  @override
  String get create => 'Create';

  @override
  String empty_error(String field) {
    return '$field cannot be empty';
  }

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get steps => 'Steps';

  @override
  String get category => 'Category';

  @override
  String get prep_time => 'Preparation time';

  @override
  String get cook_time => 'Cook time';

  @override
  String get category_info_1 =>
      'If you don\'t add a category, the recipe will be added to the \"Uncategorized\" category.';

  @override
  String get category_info_2 => 'You can add a category later.';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get no_category => 'No category';

  @override
  String get confirm_deletion_title => 'Confirm deletion';

  @override
  String delition_confirmation(String type) {
    return 'Are you sure you want to delete the typeName $type?';
  }

  @override
  String get deletion_info =>
      'If there\'s any recipe associated with this category, it will be categorized under \"Uncategorized\".';

  @override
  String get delete => 'Delete';

  @override
  String get category_empty => 'No categories registered';

  @override
  String smt_name(String something) {
    return '$something name';
  }

  @override
  String get description_placeholder => 'Tell a little bit about the recipe...';

  @override
  String get recipe_empty => 'No recipes registered';

  @override
  String get favorite_empty => 'No favorites recipes';

  @override
  String get minutes => 'minutes';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get rating => 'Rating';
}
