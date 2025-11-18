import 'package:flutter/material.dart';

class ErrorSnackbar extends StatelessWidget {
  const ErrorSnackbar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [Icon(Icons.error), SizedBox(width: 4), Text(text)],
      ),
    );
  }
}
