import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:matrix/provider/todos.dart';
import 'list_divider.dart';
import 'todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todos;

    return todos.isEmpty
        ? const Center(
            child: Text(
              "Great job!",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final todo = todos[index];
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListDivider(quadrant: todo.quadrant),
                    TodoWidget(todo: todo)
                  ],
                );
              }

              return TodoWidget(todo: todo);
            },
            separatorBuilder: (context, index) {
              final todo = todos[index + 1];
              final prevTodo = todos[index];
              if (todo.quadrant == prevTodo.quadrant) {
                return Container(height: 8);
              } else {
                return ListDivider(quadrant: todo.quadrant);
              }
            },
            itemCount: todos.length,
          );
  }
}
