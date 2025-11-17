import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  late FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => _onFocusChange());
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(() => _onFocusChange());
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return StickyHeader(
      header: Container(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text.description),
              isFocused
                  ? IconButton(
                      onPressed: () => focusNode.unfocus(),
                      icon: Icon(Icons.check),
                    )
                  : const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: widget.descriptionController,
              maxLines: null,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: text.description_placeholder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
