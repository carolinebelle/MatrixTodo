const String tableTodos = 'todos';

class TodoFields {
  static final List<String> values = [
    id,
    createdTime,
    title,
    description,
    quadrant,
    isDone
  ];

  static const String id = '_id';
  static const String createdTime = 'createdTime';
  static const String title = 'title';
  static const String description = 'description';
  static const String quadrant = 'quadrant';
  static const String isDone = 'isDone';
}

class Todo {
  final int? id;
  final DateTime createdTime;
  final String title;
  final String description;
  final bool isDone;
  final int quadrant;

  Todo({
    this.id,
    required this.createdTime,
    required this.title,
    this.description = "",
    this.isDone = false,
    this.quadrant = 0,
  });

  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.createdTime: createdTime.toIso8601String(),
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.isDone: isDone ? 1 : 0,
        TodoFields.quadrant: quadrant
      };

  Todo copy(
          {DateTime? createdTime,
          String? title,
          String? description,
          int? id,
          bool? isDone,
          int? quadrant}) =>
      Todo(
          createdTime: createdTime ?? this.createdTime,
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          quadrant: quadrant ?? this.quadrant,
          isDone: isDone ?? this.isDone);

  static Todo fromJson(Map<String, Object?> json) => Todo(
      id: json[TodoFields.id] as int?,
      createdTime: DateTime.parse(json[TodoFields.createdTime] as String),
      title: json[TodoFields.title] as String,
      description: json[TodoFields.description] as String,
      quadrant: json[TodoFields.quadrant] as int,
      isDone: json[TodoFields.isDone] == 1);

  @override
  String toString() {
    return 'Todo{id: $id, createdTime: $createdTime, title: $title, description: $description, isDone: $isDone, quadrant: $quadrant}';
  }
}
