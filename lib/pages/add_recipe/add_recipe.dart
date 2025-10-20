import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(text.add_new),
        centerTitle: true,
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}
