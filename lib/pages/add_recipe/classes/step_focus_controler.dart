import 'package:flutter/material.dart';

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
