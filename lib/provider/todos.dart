import 'package:flutter/cupertino.dart';
import '../db/todos_database.dart';
import '../model/todo.dart';

class TodosProvider extends ChangeNotifier {
  late List<Todo> _todos = [];

  TodosProvider() {
    queryDb();
  }

  Future queryDb() async {
    _todos = await TodosDatabase.instance.readAllTodos();
    notifyListeners();
  }

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  Map<String, double> get dataMapCompleted {
    Map<String, double> m = {
      "Do": 0,
      "Schedule": 0,
      "Delegate": 0,
      "Delete": 0,
      "Other": 0,
    };

    for (var t in _todos) {
      if (t.isDone) updateMap("ADD", t.quadrant, m);
    }

    return m;
  }

  Map<String, double> get dataMapWaiting {
    Map<String, double> m = {
      "Do": 0,
      "Schedule": 0,
      "Delegate": 0,
      "Delete": 0,
      "Other": 0,
    };

    for (var t in _todos) {
      if (!t.isDone) updateMap("ADD", t.quadrant, m);
    }

    return m;
  }

  Future addTodo(Todo todo) async {
    Todo dbTodo = await TodosDatabase.instance.create(todo);
    _todos.add(dbTodo);
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    notifyListeners();
  }

  Future removeTodo(Todo todo) async {
    await TodosDatabase.instance.delete(todo.id!);
    _todos.remove(todo);

    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    updateTodo(todo: todo, isDone: !todo.isDone);

    return !todo.isDone;
  }

  void updateTodo(
      {required Todo todo,
      String? title,
      String? description,
      int? quadrant,
      bool? isDone}) {
    Todo updatedTodo = todo.copy(
        title: title ?? todo.title,
        description: description ?? todo.description,
        quadrant: quadrant ?? todo.quadrant,
        isDone: isDone ?? todo.isDone);

    TodosDatabase.instance.update(updatedTodo);
    _todos.remove(todo);
    _todos.add(updatedTodo);
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    notifyListeners();
  }

  void updateMap(String action, int quadrant, Map<String, double> m) {
    switch (action) {
      case "ADD":
        switch (quadrant) {
          case 0:
            m.update("Other", (value) => value + 1);
            break; // The switch statement must be told to exit, or it will execute every case.
          case 1:
            m.update("Do", (value) => value + 1);
            break;
          case 2:
            m.update("Schedule", (value) => value + 1);
            break;
          case 3:
            m.update("Delegate", (value) => value + 1);
            break;
          case 4:
            m.update("Delete", (value) => value + 1);
            break;
        }
        break; // The switch statement must be told to exit, or it will execute every case.
      case "REMOVE":
        switch (quadrant) {
          case 0:
            m.update("Other", (value) => value - 1);
            break; // The switch statement must be told to exit, or it will execute every case.
          case 1:
            m.update("Do", (value) => value - 1);
            break;
          case 2:
            m.update("Schedule", (value) => value - 1);
            break;
          case 3:
            m.update("Delegate", (value) => value - 1);
            break;
          case 4:
            m.update("Delete", (value) => value - 1);
            break;
        }
        break;
    }
  }
}
