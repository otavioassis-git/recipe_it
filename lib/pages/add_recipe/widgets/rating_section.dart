import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

class RatingSection extends StatefulWidget {
  const RatingSection({super.key, required this.rating});

  final List<double> rating;

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomStickyHeaderContent(
          title: text.difficulty,
          content: Card(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: RatingBar.builder(
                initialRating: widget.rating[0],
                itemBuilder: (_, _) => Icon(Icons.star),
                onRatingUpdate: (value) => setState(() {
                  widget.rating[0] = value;
                }),
              ),
            ),
          ),
        ),
        CustomStickyHeaderContent(
          title: text.rating,
          content: Card(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: RatingBar.builder(
                initialRating: widget.rating[1],
                itemBuilder: (context, index) => Icon(Icons.star),
                onRatingUpdate: (value) => setState(() {
                  widget.rating[1] = value;
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
