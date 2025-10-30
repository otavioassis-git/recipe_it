import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get home;

  /// Favorites screen title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Appearance settings title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Search screen title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Add button title
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Recipe screen title
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipe;

  /// Add new screen footer button title
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Empty field error message
  ///
  /// In en, this message translates to:
  /// **'{field} cannot be empty'**
  String empty_error(String field);

  /// Recipe name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Recipe description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Recipe ingredients field label
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Recipe steps field label
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// Recipe category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Recipe prep time field label
  ///
  /// In en, this message translates to:
  /// **'Preparation time'**
  String get prep_time;

  /// Recipe cook time field label
  ///
  /// In en, this message translates to:
  /// **'Cook time'**
  String get cook_time;

  /// Recipe total time field label
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get total_time;

  /// Recipe category info message
  ///
  /// In en, this message translates to:
  /// **'If you don\'t add a category, the recipe will be added to the \"Uncategorized\" category.'**
  String get category_info_1;

  /// Recipe category info message
  ///
  /// In en, this message translates to:
  /// **'You can add a category later.'**
  String get category_info_2;

  /// Close button title
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Cancel button title
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No category label
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get no_category;

  /// Confirm deletion dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirm_deletion_title;

  /// Confirm deletion dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the typeName {type}?'**
  String delition_confirmation(String type);

  /// Confirm deletion dialog info message
  ///
  /// In en, this message translates to:
  /// **'If there\'s any recipe associated with this category, it will be categorized under \"Uncategorized\".'**
  String get deletion_info;

  /// Delete button title
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Category empty message
  ///
  /// In en, this message translates to:
  /// **'No categories registered'**
  String get category_empty;

  /// Category name field label
  ///
  /// In en, this message translates to:
  /// **'{something} name'**
  String smt_name(String something);

  /// Recipe description placeholder
  ///
  /// In en, this message translates to:
  /// **'Tell a little bit about the recipe...'**
  String get description_placeholder;

  /// Recipe empty message
  ///
  /// In en, this message translates to:
  /// **'No recipes registered'**
  String get recipe_empty;

  /// Favorite empty message
  ///
  /// In en, this message translates to:
  /// **'No favorites recipes'**
  String get favorite_empty;

  /// Minute label
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Difficulty label
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
