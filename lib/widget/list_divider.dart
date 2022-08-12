import "package:flutter/material.dart";

class ListDivider extends StatelessWidget {
  const ListDivider({Key? key, required this.quadrant}) : super(key: key);
  final int quadrant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 20, 4),
      child: Text(
        getLabel(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
          // decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  String getLabel() {
    switch (quadrant) {
      case (1):
        return "Do now: ";
      case (2):
        return "Schedule: ";
      case (3):
        return "Delegate: ";
      case (4):
        return "Delete: ";
      default:
        return "Sort: ";
    }
  }
}
