import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/models/recipe_model.dart';

class ScoringTimingSection extends StatelessWidget {
  const ScoringTimingSection({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16,
          children: [
            Expanded(child: Text(text.prep_time)),
            Expanded(child: Text(text.cook_time)),
            Expanded(child: Text(text.total_time)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('${recipe.prepTime} ${text.minutes}'),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('${recipe.prepTime} ${text.minutes}'),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('${recipe.totalTime} ${text.minutes}'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          spacing: 16,
          children: [
            Expanded(child: Text(text.difficulty)),
            Expanded(child: Text(text.rating)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RatingBar.builder(
                    initialRating: recipe.difficulty,
                    itemSize: 18,
                    itemBuilder: (_, _) => Icon(Icons.star),
                    onRatingUpdate: (value) {},
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RatingBar.builder(
                    initialRating: recipe.rating,
                    itemSize: 18,
                    itemBuilder: (_, _) => Icon(Icons.star),
                    onRatingUpdate: (value) {},
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
