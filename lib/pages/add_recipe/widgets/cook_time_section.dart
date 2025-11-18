import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

class CookTimeSection extends StatefulWidget {
  const CookTimeSection({super.key, required this.cookTimeController});

  final TextEditingController cookTimeController;

  @override
  State<CookTimeSection> createState() => _CookTimeSectionState();
}

class _CookTimeSectionState extends State<CookTimeSection> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return CustomStickyHeaderContent(
      title: text.cook_time,
      content: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.cookTimeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: text.cook_time,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Text(text.minutes),
            ],
          ),
        ),
      ),
    );
  }
}
