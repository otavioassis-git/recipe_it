import 'package:flutter/material.dart';
import 'package:recipe_it/data/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
