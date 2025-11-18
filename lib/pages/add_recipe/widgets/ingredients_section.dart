import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

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

    void addIngredient() {
      setState(() {
        widget.ingredientsControllers.add(TextEditingController());
        focusNodes.add(FocusNode());
        focusNodes[focusNodes.length - 1].requestFocus();
      });
    }

    void removeIngredient(int index) {
      setState(() {
        widget.ingredientsControllers.removeAt(index);
        focusNodes[index].dispose();
        focusNodes.removeAt(index);
        focusNodes[index == 0 ? index : index - 1].requestFocus();
      });
    }

    return CustomStickyHeaderContent(
      title: text.ingredients,
      showAction: true,
      actionFunction: addIngredient,
      actionIcon: Icon(Icons.add),
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
                        onPressed: () => removeIngredient(i),
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
