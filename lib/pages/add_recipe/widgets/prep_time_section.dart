import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

class PrepTimeSection extends StatefulWidget {
  const PrepTimeSection({
    super.key,
    required this.prepTimeController,
    required this.cookTimeController,
  });

  final TextEditingController prepTimeController;
  final TextEditingController cookTimeController;

  @override
  State<PrepTimeSection> createState() => _PrepTimeSectionState();
}

class _PrepTimeSectionState extends State<PrepTimeSection> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(text.prep_time), SizedBox(height: 48)]),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
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
                const SizedBox(width: 8),
                Text(text.min),
                const SizedBox(width: 16),
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
                const SizedBox(width: 8),
                Text(text.min),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
