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
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            themeModeNotifier.value = ThemeMode.system;
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: themeMode == ThemeMode.system
                                ? colorScheme.inversePrimary
                                : colorScheme.surface,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "System",
                            style: TextStyle(
                              color: themeMode == ThemeMode.system
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            themeModeNotifier.value = ThemeMode.dark;
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: themeMode == ThemeMode.dark
                                ? colorScheme.inversePrimary
                                : colorScheme.surface,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Dark",
                            style: TextStyle(
                              color: themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            themeModeNotifier.value = ThemeMode.light;
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: themeMode == ThemeMode.light
                                ? colorScheme.inversePrimary
                                : colorScheme.surface,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Light",
                            style: TextStyle(
                              color: themeMode == ThemeMode.light
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
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
