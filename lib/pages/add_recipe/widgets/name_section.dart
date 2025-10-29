import 'package:flutter/material.dart';

class NameSection extends StatelessWidget {
  const NameSection({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: 'Recipe name',
        border: OutlineInputBorder(),
      ),
    );
  }
}
