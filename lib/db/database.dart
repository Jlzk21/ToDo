/* Copyright 2023, Julius Biascan */

import 'package:group2/model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ToDo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, dateandtime TEXT NOT NULL)");
  }

  Future<ToDoModel> insert(ToDoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('ToDo', todoModel.toMap());
    return todoModel;
  }

  Future<List<ToDoModel>> getTodoList() async {
    await db;
    final List<Map<String, Object?>> qr =
        await _db!.rawQuery("SELECT * FROM ToDo");
    return qr.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('ToDo', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItem(ToDoModel toDoModel) async {
    var dbClient = await db;
    return await dbClient!.update('ToDo', toDoModel.toMap(),
        where: 'id = ?', whereArgs: [toDoModel.id]);
  }
}
