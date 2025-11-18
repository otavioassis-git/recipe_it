import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

class PrepTimeSection extends StatefulWidget {
  const PrepTimeSection({super.key, required this.prepTimeController});

  final TextEditingController prepTimeController;

  @override
  State<PrepTimeSection> createState() => _PrepTimeSectionState();
}

class _PrepTimeSectionState extends State<PrepTimeSection> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return CustomStickyHeaderContent(
      title: text.prep_time,
      content: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.prepTimeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: text.prep_time,
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
