import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';
import '../provider/todos.dart';
import '../utils.dart';
import 'add_todo_dialog_widget.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (BuildContext context) => showDialog(
                  context: context,
                  builder: (_) => AddTodoDialogWidget(todo: todo),
                ),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          endActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (_) => deleteTodo(context, todo),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: buildTodo(context),
        ),
      );

  Widget buildTodo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            checkColor: Colors.white,
            value: todo.isDone,
            onChanged: (_) {
              final provider =
                  Provider.of<TodosProvider>(context, listen: false);
              final isDone = provider.toggleTodoStatus(todo);
              Utils.showSnackBar(context,
                  isDone ? "Task completed" : "Task marked incomplete");
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                if (todo.description.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(
                      todo.description,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    Color fontColor = Theme.of(context).primaryColor;

    if (todo.quadrant != 0) {
      if (todo.quadrant == 1) {
        // urgent and important
        fontColor = Colors.green;
      } else if (todo.quadrant == 2) {
        // not ugent but important
        fontColor = Colors.yellow;
      } else if (todo.quadrant == 3) {
        // delegate it
        fontColor = Colors.orange;
      } else {
        // trash it
        fontColor = Colors.red;
      }
    }

    return Text(
      todo.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: fontColor,
        fontSize: 22,
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);

    Utils.showSnackBar(context, "Todo item was deleted.");
  }
}
