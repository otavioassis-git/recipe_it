import 'package:recipe_it/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceSetting extends StatelessWidget {
  const AppearanceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final text = AppLocalizations.of(context)!;

    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(text.appearance, style: theme.textTheme.bodySmall),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceContainerHighest,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surface,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    spacing: 4,
                    children: [
                      CustomSelectButton(
                        selectedThemeMode: themeMode,
                        label: text.system,
                        value: ThemeMode.system,
                      ),
                      CustomSelectButton(
                        selectedThemeMode: themeMode,
                        label: text.dark,
                        value: ThemeMode.dark,
                      ),
                      CustomSelectButton(
                        selectedThemeMode: themeMode,
                        label: text.light,
                        value: ThemeMode.light,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomSelectButton extends StatelessWidget {
  const CustomSelectButton({
    super.key,
    required this.selectedThemeMode,
    required this.label,
    required this.value,
  });

  final ThemeMode selectedThemeMode;
  final String label;
  final ThemeMode value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final themeModeStringMap = {
      ThemeMode.system: "ThemeMode.system",
      ThemeMode.dark: "ThemeMode.dark",
      ThemeMode.light: "ThemeMode.light",
    };

    return Expanded(
      child: TextButton(
        onPressed: () async {
          themeModeNotifier.value = value;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('themeMode', themeModeStringMap[value]!);
        },
        style: TextButton.styleFrom(
          backgroundColor: selectedThemeMode == value
              ? colorScheme.inversePrimary
              : colorScheme.surface,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectedThemeMode == value
                ? Colors.white
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
