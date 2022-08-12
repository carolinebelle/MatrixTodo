import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:matrix/provider/todos.dart';
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
              return TodoWidget(todo: todo);
            },
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: todos.length,
          );
  }
}
