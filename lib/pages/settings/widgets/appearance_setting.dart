import 'package:recipe_it/data/notifiers.dart';
import 'package:flutter/material.dart';

class AppearanceSetting extends StatelessWidget {
  const AppearanceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
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
                        label: "System",
                      ),
                      CustomSelectButton(
                        selectedThemeMode: themeMode,
                        label: "Dark",
                      ),
                      CustomSelectButton(
                        selectedThemeMode: themeMode,
                        label: "Light",
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
  });

  final ThemeMode selectedThemeMode;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final themeModeLabelMap = {
      "System": ThemeMode.system,
      "Dark": ThemeMode.dark,
      "Light": ThemeMode.light,
    };

    return Expanded(
      child: TextButton(
        onPressed: () => themeModeNotifier.value = themeModeLabelMap[label],
        style: TextButton.styleFrom(
          backgroundColor: selectedThemeMode == themeModeLabelMap[label]
              ? colorScheme.inversePrimary
              : colorScheme.surface,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectedThemeMode == themeModeLabelMap[label]
                ? Colors.white
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
