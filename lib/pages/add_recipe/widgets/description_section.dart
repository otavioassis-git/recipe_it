import 'package:flutter/material.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  late FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => _onFocusChange());
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(() => _onFocusChange());
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Description'),
            isFocused
                ? IconButton(
                    onPressed: () => focusNode.unfocus(),
                    icon: Icon(Icons.check),
                  )
                : const SizedBox(height: 48),
          ],
        ),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: widget.descriptionController,
              maxLines: null,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Tell a little bit about the recipe...',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
