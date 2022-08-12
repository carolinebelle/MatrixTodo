import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
  const TodoFormWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            const SizedBox(height: 8),
            buildDescription(),
          ],
        ),
      );

  Widget buildTitle() => TextFormField(
        initialValue: title,
        validator: (title) {
          if (title!.isEmpty) {
            return "The title cannot be empty.";
          }
          return null;
        },
        onChanged: onChangedTitle,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), labelText: 'Title'),
      );

  Widget buildDescription() => TextFormField(
        initialValue: description,
        onChanged: onChangedDescription,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), labelText: 'Description'),
      );
}
