import 'package:flutter/material.dart';
import 'package:matrix/model/todo.dart';
import 'package:matrix/provider/todos.dart';
import 'package:matrix/widget/quadrant_target.dart';
import 'package:matrix/widget/todo_form_widget.dart';
import 'package:provider/provider.dart';

class AddTodoDialogWidget extends StatefulWidget {
  const AddTodoDialogWidget({Key? key, this.todo}) : super(key: key);

  final Todo? todo;

  @override
  State<AddTodoDialogWidget> createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  bool dragging = false;
  bool editedTitle = false;
  bool editedDesc = false;

  @override
  Widget build(BuildContext context) {
    return (Form(
      key: _formKey,
      child: Stack(
        children: [
          _buildDraggable(context),
          if (dragging) _buildQuadrant(context)
        ],
      ),
    ));
  }

  Widget _buildDraggable(BuildContext context) {
    return (LongPressDraggable<Todo>(
      data: Todo(
        id: "unique id",
        createdTime: DateTime.now(),
        title: title,
        description: description,
      ),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => setState(() {
        dragging = true;
      }),
      onDragEnd: (DraggableDetails details) => setState(() {
        dragging = false;
      }),
      onDragCompleted: () {},
      feedback: const Icon(Icons.task, color: Colors.white, size: 30),
      childWhenDragging: Center(
          child: Icon(Icons.task, color: (Colors.orange).withOpacity(0.0))),
      child: _buildDialog(context),
    ));
  }

  Widget _buildDialog(BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Todo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TodoFormWidget(
              title: title == ""
                  ? widget.todo != null
                      ? widget.todo!.title
                      : title
                  : title,
              description: description == ""
                  ? widget.todo != null
                      ? widget.todo!.description
                      : description
                  : description,
              onChangedTitle: (title) => setState(() {
                this.title = title;
                if (!editedTitle) {
                  editedTitle = true;
                }
              }),
              onChangedDescription: (description) => setState(() {
                this.description = description;
                if (!editedDesc) {
                  editedDesc = true;
                }
              }),
            )
          ],
        ),
      );

  Widget _buildQuadrant(BuildContext context) => Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                QuadrantTarget(
                  context: context,
                  color: const Color.fromARGB(255, 214, 198, 49),
                  label: "High Importance, Low Urgency",
                  onSavedTodo: addTodo,
                  quadrant: 2,
                ),
                QuadrantTarget(
                  context: context,
                  color: Colors.green,
                  label: "High Importance, High Urgency",
                  onSavedTodo: addTodo,
                  quadrant: 1,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                QuadrantTarget(
                  context: context,
                  color: Colors.red,
                  label: "Low Importance, Low Urgency",
                  onSavedTodo: addTodo,
                  quadrant: 4,
                ),
                QuadrantTarget(
                  context: context,
                  color: Colors.orange,
                  label: "Low Importance, High Urgency",
                  onSavedTodo: addTodo,
                  quadrant: 3,
                ),
              ],
            ),
          )
        ],
      );

  void addTodo(int quadrant) {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    } else {
      final provider = Provider.of<TodosProvider>(context, listen: false);
      if (widget.todo != null) {
        provider.updateTodo(
            widget.todo!,
            editedTitle ? title : widget.todo!.title,
            editedDesc ? description : widget.todo!.description,
            quadrant);
      } else {
        final todo = Todo(
          createdTime: DateTime.now(),
          id: DateTime.now().toString(),
          title: title,
          description: description,
          quadrant: quadrant,
        );

        provider.addTodo(todo);
      }

      Navigator.of(context).pop();
    }
  }
}
