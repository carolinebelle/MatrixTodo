import 'package:flutter/cupertino.dart';
import '../model/todo.dart';

class TodosProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  final Map<String, double> _map = {
    "Do": 1,
    "Schedule": 0,
    "Delegate": 0,
    "Delete": 0,
    "Other": 0,
  };

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  Map<String, double> get dataMap => _map;

  void addTodo(Todo todo) {
    _todos.add(todo);
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    updateMap("ADD", todo.quadrant);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);

    updateMap("REMOVE", todo.quadrant);

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
      updateMap("REMOVE", todo.quadrant); // remove old quadrant
      updateMap("ADD", quadrant); // add new quadrant
      todo.quadrant = quadrant;
    }
    _todos.sort((a, b) => a.quadrant.compareTo(b.quadrant));

    notifyListeners();
  }

  void updateMap(String action, int quadrant) {
    switch (action) {
      case "ADD":
        switch (quadrant) {
          case 0:
            _map.update("Other", (value) => value + 1);
            break; // The switch statement must be told to exit, or it will execute every case.
          case 1:
            _map.update("Do", (value) => value + 1);
            break;
          case 2:
            _map.update("Schedule", (value) => value + 1);
            break;
          case 3:
            _map.update("Delegate", (value) => value + 1);
            break;
          case 4:
            _map.update("Delete", (value) => value + 1);
            break;
        }
        break; // The switch statement must be told to exit, or it will execute every case.
      case "REMOVE":
        switch (quadrant) {
          case 0:
            _map.update("Other", (value) => value - 1);
            break; // The switch statement must be told to exit, or it will execute every case.
          case 1:
            _map.update("Do", (value) => value - 1);
            break;
          case 2:
            _map.update("Schedule", (value) => value - 1);
            break;
          case 3:
            _map.update("Delegate", (value) => value - 1);
            break;
          case 4:
            _map.update("Delete", (value) => value - 1);
            break;
        }
        break;
    }
  }
}
