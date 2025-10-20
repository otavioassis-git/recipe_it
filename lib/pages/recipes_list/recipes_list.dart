import 'package:flutter/cupertino.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

class RecipesList extends StatelessWidget {
  const RecipesList({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Text(text.helloWorld);
  }
}
