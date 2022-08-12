class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String description;
  String id;
  bool isDone;
  int quadrant;

  Todo({
    required this.createdTime,
    required this.title,
    this.description = "",
    required this.id,
    this.isDone = false,
    this.quadrant = 0,
  });
}
