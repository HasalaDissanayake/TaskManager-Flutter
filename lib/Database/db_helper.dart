import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = "${await getDatabasesPath()}/task_database.db";
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Database is creating");
          return db.execute(
            "CREATE TABLE $_tableName("
            "task_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "task_title STRING, task_description TEXT, category STRING, "
            "task_date STRING, task_time STRING, priority STRING, "
            "remind INTEGER, is_completed INTEGER, attachment BLOB)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // returns id of last inserted row
  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 0;
  }

  //to get all data from database
  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  //to delete a task
  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'task_id=?', whereArgs: [task.taskId]);
  }

  // to update a task state
  static updateState(int taskId) async {
    await _db!.rawUpdate('''
      UPDATE tasks
      SET is_completed = ?
      WHERE task_id = ?
    ''', [1, taskId]);
  }

  static Future<int> update(Task? task) async {
    return await _db?.update(_tableName, task!.toJson(),
            where: 'task_id=?', whereArgs: [task.taskId]) ??
        0;
  }
}
