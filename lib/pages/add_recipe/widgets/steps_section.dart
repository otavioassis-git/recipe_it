import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
import 'package:recipe_it/pages/add_recipe/classes/step_focus_controler.dart';
import 'package:recipe_it/widgets/custom_sticky_header_content.dart';

class StepsSection extends StatefulWidget {
  const StepsSection({super.key, required this.stepsControllers});

  final List<TextEditingController> stepsControllers;

  @override
  State<StepsSection> createState() => _StepsSectionState();
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

    void addStep() {
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
        stepFocusControllers[stepFocusControllers.length - 1].focusNode
            .requestFocus();
      });
    }

    void removeStep(int index) {
      setState(() {
        if (stepFocusControllers[index].isFocused) {
          stepFocusControllers[index].focusNode.unfocus();
        } else {
          widget.stepsControllers[index].dispose();
          widget.stepsControllers.remove(widget.stepsControllers[index]);
          stepFocusControllers[index].dispose();
          stepFocusControllers.remove(stepFocusControllers[index]);
        }
      });
    }

    return CustomStickyHeaderContent(
      title: text.steps,
      showAction: true,
      actionFunction: addStep,
      actionIcon: Icon(Icons.add),
      content: Card(
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
                        onPressed: () => removeStep(i),
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
    );
  }
}
