import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class StepsSection extends StatefulWidget {
  const StepsSection({super.key, required this.stepsControllers});

  final List<TextEditingController> stepsControllers;

  @override
  State<StepsSection> createState() => _StepsSectionState();
}

class StepFocusController {
  int id = -1;
  final FocusNode focusNode;
  final VoidCallback listener;
  bool isFocused = false;

  static int autoincrementId = 0;

  StepFocusController({required this.focusNode, required this.listener})
    : super() {
    id = autoincrementId;
    StepFocusController.incrementId();
    focusNode.addListener(listener);
  }

  static void incrementId() {
    autoincrementId++;
  }

  static void resetId() {
    autoincrementId = 0;
  }

  void removeListener() {
    focusNode.removeListener(listener);
  }

  void dispose() {
    focusNode.unfocus();
    removeListener();
    focusNode.dispose();
  }
}

class _StepsSectionState extends State<StepsSection> {
  bool isKeyboardUp = false;

  final List<StepFocusController> stepFocusControllers = [];

  @override
  void initState() {
    StepFocusController.resetId();
    for (int i = 0; i < widget.stepsControllers.length; i++) {
      int id = StepFocusController.autoincrementId;
      stepFocusControllers.add(
        StepFocusController(
          focusNode: FocusNode(),
          listener: () => _onFocusChange(id),
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < stepFocusControllers.length; i++) {
      stepFocusControllers[i].dispose();
    }
    super.dispose();
  }

  void _onFocusChange(int id) {
    setState(() {
      final int index = stepFocusControllers.indexWhere(
        (element) => element.id == id,
      );
      stepFocusControllers[index].isFocused =
          stepFocusControllers[index].focusNode.hasFocus;
      isKeyboardUp = stepFocusControllers.any((e) => e.isFocused);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return StickyHeader(
      header: Container(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text.steps),
              IconButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < stepFocusControllers.length; i++) {
                      stepFocusControllers[i].focusNode.unfocus();
                    }
                    int id = StepFocusController.autoincrementId;
                    stepFocusControllers.add(
                      StepFocusController(
                        focusNode: FocusNode(),
                        listener: () => _onFocusChange(id),
                      ),
                    );
                    widget.stepsControllers.add(TextEditingController());
                    stepFocusControllers[stepFocusControllers.length - 1]
                        .focusNode
                        .requestFocus();
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 4,
              children: [
                for (int i = 0; i < stepFocusControllers.length; i++)
                  Row(
                    children: [
                      Text('${i + 1}.', style: theme.textTheme.titleMedium),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          focusNode: stepFocusControllers[i].focusNode,
                          controller: widget.stepsControllers[i],
                          maxLines: null,
                        ),
                      ),
                      if (stepFocusControllers.length > 1 || isKeyboardUp)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (stepFocusControllers[i].isFocused) {
                                stepFocusControllers[i].focusNode.unfocus();
                              } else {
                                widget.stepsControllers[i].dispose();
                                widget.stepsControllers.remove(
                                  widget.stepsControllers[i],
                                );
                                stepFocusControllers[i].dispose();
                                stepFocusControllers.remove(
                                  stepFocusControllers[i],
                                );
                              }
                            });
                          },
                          icon: Icon(
                            stepFocusControllers[i].isFocused
                                ? Icons.check
                                : Icons.delete,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
