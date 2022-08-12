import 'package:flutter/cupertino.dart';
import '../model/todo.dart';

class TodosProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  final Map<String, double> _map = {
    "Do": 0,
    "Schedule": 0,
    "Delegate": 0,
    "Delete": 0,
    "Other": 0,
  };

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  Map<String, double> get dataMap => _map;

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

  void addTodo(Todo todo) {
    _todos.add(todo);
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    updateMap("ADD", todo.quadrant, _map);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);

    updateMap("REMOVE", todo.quadrant, _map);

    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    notifyListeners();
    return todo.isDone;
  }

  void updateTodo(Todo todo, String title, String description, int quadrant) {
    todo.title = title;
    todo.description = description;
    if (todo.quadrant != quadrant) {
      updateMap("REMOVE", todo.quadrant, _map); // remove old quadrant
      updateMap("ADD", quadrant, _map); // add new quadrant
      todo.quadrant = quadrant;
    }
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
