import 'package:sqflite/sqflite.dart';
import 'package:matrix/model/todo.dart';
import 'package:path/path.dart';

class TodosDatabase {
  static final TodosDatabase instance = TodosDatabase._init();

  static Database? _database;

  TodosDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const createdTimeType = 'TEXT NOT NULL';
    const titleType = 'TEXT NOT NULL';
    const descriptionType = 'TEXT';
    const quadrantType = 'INTEGER';
    const isDoneType = 'BOOLEAN NOT NULL';

    await db.execute('''CREATE TABLE $tableTodos (
          ${TodoFields.id} $idType, 
          ${TodoFields.createdTime} $createdTimeType, 
          ${TodoFields.title} $titleType, 
          ${TodoFields.description} $descriptionType, 
          ${TodoFields.quadrant} $quadrantType, 
          ${TodoFields.isDone} $isDoneType 
          )''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert(tableTodos, todo.toJson());

    return todo.copy(id: id);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableTodos,
        columns: TodoFields.values,
        where: '${TodoFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    const orderBy = '${TodoFields.quadrant} ASC';
    final result = await db.query(tableTodos, orderBy: orderBy);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return db.update(tableTodos, todo.toJson(),
        where: '${TodoFields.id} = ?', whereArgs: [todo.id]);
  }

  Future delete(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableTodos, where: '${TodoFields.id} = ?', whereArgs: [id]);
  }
}
