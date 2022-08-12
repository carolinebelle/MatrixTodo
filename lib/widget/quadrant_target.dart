import "package:flutter/material.dart";

class QuadrantTarget extends StatefulWidget {
  const QuadrantTarget(
      {Key? key,
      required this.context,
      required this.color,
      required this.label,
      required this.onSavedTodo,
      required this.quadrant})
      : super(key: key);
  final BuildContext context;
  final Color color;
  final String label;
  final int quadrant;
  final void Function(int) onSavedTodo;

  @override
  State<QuadrantTarget> createState() => _QuadrantTargetState();
}

class _QuadrantTargetState extends State<QuadrantTarget> {
  bool willAcceptOnDrop = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: DragTarget(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return Opacity(
            opacity: willAcceptOnDrop ? 1.0 : 0.75,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: widget.color,
                  blurRadius: willAcceptOnDrop ? 10.0 : 0.0,
                ),
              ], color: widget.color),
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        onWillAccept: (data) {
          setState(() {
            willAcceptOnDrop = true;
          });
          return true;
        },
        onLeave: (data) {
          setState(() {
            willAcceptOnDrop = false;
          });
        },
        onAccept: (data) {
          widget.onSavedTodo(widget.quadrant);
        },
      ),
    );
  }
}
