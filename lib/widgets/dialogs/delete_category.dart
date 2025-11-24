import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

Future<bool?> showDeleteCategoryDialog(
  BuildContext context,
  String categoryName,
) {
  final text = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return showDialog<bool>(
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
              text.confirm_deletion_title,
              style: theme.textTheme.headlineSmall,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: text
                        .delition_confirmation(text.category.toLowerCase())
                        .split("typeName")[0],
                  ),
                  TextSpan(
                    text: categoryName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: text
                        .delition_confirmation(text.category.toLowerCase())
                        .split("typeName")[1],
                  ),
                ],
              ),
            ),
            Text(text.deletion_info),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(text.close),
                ),
                SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: Text(text.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
