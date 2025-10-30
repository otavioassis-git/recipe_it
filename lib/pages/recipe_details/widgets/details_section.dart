import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    super.key,
    required this.title,
    required this.contents,
    this.numering,
  });

  final String title;
  final List<String> contents;
  final bool? numering;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int i = -1;
    final content = contents.map((e) {
      i++;
      return numering == true
          ? Row(
              spacing: 4,
              children: [
                Text('${i + 1}.', style: theme.textTheme.titleMedium),
                Text(e),
              ],
            )
          : Text(e);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(children: [Text(title), SizedBox(height: 48)]),
        Row(
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
