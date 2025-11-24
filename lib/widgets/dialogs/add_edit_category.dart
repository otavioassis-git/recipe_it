import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/widgets/snackbars/error_snackbar.dart';

Future<String?> showAddEditCategoryDialog(
  BuildContext context,
  bool isEdit,
  String categoryName,
) {
  final text = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final TextEditingController nameController = TextEditingController(
    text: isEdit == true ? categoryName : '',
  );

  return showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              '${isEdit == true ? text.edit : text.add} ${text.category}',
              style: theme.textTheme.headlineSmall,
            ),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: text.smt_name(text.category),
                border: const OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Text(text.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty) {
                      if (context.mounted) {
                        Navigator.pop(context, nameController.text);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        ErrorSnackbar(text: 'Please enter a name'),
                      );
                    }
                  },
                  child: Text(isEdit == true ? text.edit : text.add),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
