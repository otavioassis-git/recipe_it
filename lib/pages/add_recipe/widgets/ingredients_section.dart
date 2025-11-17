import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers.dart';

class IngredientsSection extends StatefulWidget {
  const IngredientsSection({super.key, required this.ingredientsControllers});

  final List<TextEditingController> ingredientsControllers;

  @override
  State<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  final List<FocusNode> focusNodes = [];

  @override
  void initState() {
    for (int i = 0; i < widget.ingredientsControllers.length; i++) {
      focusNodes.add(FocusNode());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return StickyHeader(
      header: Container(
        color: theme.colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text.ingredients),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.ingredientsControllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                  focusNodes[focusNodes.length - 1].requestFocus();
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
      content: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 4,
            children: [
              for (int i = 0; i < widget.ingredientsControllers.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.ingredientsControllers[i],
                        focusNode: focusNodes[i],
                      ),
                    ),
                    if (widget.ingredientsControllers.length > 1)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.ingredientsControllers.removeAt(i);
                            focusNodes[i].dispose();
                            focusNodes.removeAt(i);
                            focusNodes[i == 0 ? i : i - 1].requestFocus();
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
