import "package:flutter/material.dart";
import 'package:matrix/widget/todo_pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:matrix/widget/todo_widget.dart';
import '../provider/todos.dart';

class CompletedListWidget extends StatelessWidget {
  const CompletedListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todosCompleted;

    return todos.isEmpty
        ? const Center(
            child: Text(
              "Better get to work!",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        : Column(children: [
            const Expanded(
              flex: 1,
              child: ToDoPieChart(),
            ),
            Expanded(
              flex: 1,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoWidget(todo: todo);
                },
                separatorBuilder: (context, index) => Container(height: 8),
                itemCount: todos.length,
              ),
            ),
          ]);
  }
}
