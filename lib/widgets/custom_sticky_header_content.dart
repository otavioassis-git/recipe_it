import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CustomStickyHeaderContent extends StatelessWidget {
  const CustomStickyHeaderContent({
    super.key,
    required this.title,
    required this.content,
    this.infoText,
    this.actionFunction,
    this.actionIcon,
    this.showAction = false,
    this.titlePadding = true,
    this.contentPadding = true,
  });

  final String title;
  final Widget content;
  final List<String>? infoText;
  final Function? actionFunction;
  final Icon? actionIcon;
  final bool showAction;
  final bool titlePadding;
  final bool contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context)!;

    void showInfoDialog() {
      showDialog(
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
                Text('Info', style: theme.textTheme.headlineSmall),
                ...infoText!.map((e) => Text(e)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(text.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StickyHeader(
      header: Container(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: titlePadding ? 16.0 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(title),
                  if (infoText != null)
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: IconButton(
                        iconSize: 18,
                        padding: EdgeInsets.all(0),
                        onPressed: () => showInfoDialog(),
                        icon: Icon(Icons.info_outline),
                      ),
                    ),
                ],
              ),
              showAction
                  ? IconButton(
                      onPressed: () => actionFunction!(),
                      icon: actionIcon!,
                    )
                  : const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: contentPadding ? 16.0 : 0),
        child: content,
      ),
    );
  }
}
