import 'package:flutter/material.dart';

class CreateArchive extends StatefulWidget {
  const CreateArchive({super.key});

  @override
  State<CreateArchive> createState() => _CreateArchiveState();
}

class _CreateArchiveState extends State<CreateArchive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new'),
        centerTitle: true,
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}
