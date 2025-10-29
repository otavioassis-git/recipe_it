import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';

class StepsSection extends StatefulWidget {
  const StepsSection({super.key, required this.stepsControllers});

  final List<TextEditingController> stepsControllers;

  @override
  State<StepsSection> createState() => _StepsSectionState();
}

class _StepsSectionState extends State<StepsSection> {
  final List<FocusNode> focusNodes = [];
  final List<bool> isFocused = [];
  bool isKeyboardUp = false;

  @override
  void initState() {
    focusNodes.add(FocusNode());
    isFocused.add(false);
    focusNodes[0].addListener(() => _onFocusChange(0));
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].removeListener(() => _onFocusChange(i));
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _onFocusChange(int index) {
    setState(() {
      isFocused[index] = focusNodes[index].hasFocus;
      isKeyboardUp = isFocused.any((e) => e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text.steps),
            IconButton(
              onPressed: () {
                setState(() {
                  isFocused[isFocused.length - 1] = false;
                  widget.stepsControllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                  isFocused.add(false);
                  focusNodes[focusNodes.length - 1].addListener(
                    () => _onFocusChange(focusNodes.length - 1),
                  );
                  focusNodes[focusNodes.length - 1].requestFocus();
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 4,
              children: [
                for (int i = 0; i < widget.stepsControllers.length; i++)
                  Row(
                    children: [
                      Text('${i + 1}.', style: theme.textTheme.titleMedium),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          focusNode: focusNodes[i],
                          controller: widget.stepsControllers[i],
                          maxLines: null,
                        ),
                      ),
                      if (widget.stepsControllers.length > 1 || isKeyboardUp)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isFocused[i]) {
                                focusNodes[i].unfocus();
                              } else {
                                widget.stepsControllers.removeAt(i);
                                focusNodes[i].removeListener(
                                  () => _onFocusChange(i),
                                );
                                focusNodes[i].dispose();
                                focusNodes.removeAt(i);
                                isFocused.removeAt(i);
                                focusNodes[i == 0 ? i : i - 1].requestFocus();
                              }
                            });
                          },
                          icon: Icon(isFocused[i] ? Icons.check : Icons.delete),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
