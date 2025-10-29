import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

class NameSection extends StatelessWidget {
  const NameSection({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: text.smt_name(text.recipe),
        border: OutlineInputBorder(),
      ),
    );
  }
}
