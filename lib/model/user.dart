import 'package:dosis_exacta/model/database.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "user";

class User {

  int? id;
  late String name;

  User({ required this.name });

  Future save() async {
    Database db = await openDB();
    id = await db.insert(tableName, _toMap());
    db.close();
  }

  static Future<List<User>?> getAll() async {
    Database db = await openDB();
    List<Map> maps = await db.query(tableName);
    db.close();
    return maps.map((map) => User.fromMap(map)).toList();
  }

  static Future<User?> get(int id) async {

    Database db = await openDB();

    List<Map> maps = await db.query(
      "SELECT * FROM " + tableName,
      columns: ["id", "name"],
      where: "id = ?",
      whereArgs: [id]
    );

    db.close();

    return maps.map((map) => User.fromMap(map)).toList().first;

  }

  Future delete() async {
    Database db = await openDB();
    if(id == null) throw Exception("User id is null");
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Future update({ name }) async {
    Database db = await openDB();
    if(name != null) this.name = name;
    await db.update(tableName, _toMap(), where: "id = ?", whereArgs: [id]);
    db.close();

  }

  Map<String, Object?> _toMap() {
    var map = <String, Object?> {
      "name": name,
    };
    if(id != null) map["id"] = id;
    return map;
  }

  User.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    name = map["name"] as String;
  }

}