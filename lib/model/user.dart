import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "user";

class User {

  static late Database db;

  int? id;
  late String name;

  User({ required this.name });

  static Future _open() async {

    String path = await getDatabasesPath();

    db = await openDatabase(
      join(path, 'dosis_exacta.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableName ( 
            id integer primary key autoincrement, 
            name text not null
          )
        ''');
      }
    );

  }

  static Future _close() async {
    await db.close();
  }

  Future save() async {
    await _open();
    id = await db.insert(tableName, _toMap());
    _close();
  }

  static Future<List<User>?> getAll() async {

    await _open();

    List<Map> maps = await db.query(tableName);
    _close();

    return maps.map((map) => User.fromMap(map)).toList();

  }

  static Future<User?> get(int id) async {

    await _open();

    List<Map> maps = await db.query(
      "SELECT * FROM " + tableName,
      columns: ["id", "name"],
      where: "id = ?",
      whereArgs: [id]
    );

    _close();

    return maps.map((map) => User.fromMap(map)).toList().first;

  }

  Future delete() async {

    await _open();

    if(id == null) throw Exception("User id is null");
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);

    await _close();

  }

  Future update({ name }) async {

    _open();

    if(name != null) this.name = name;

    await db.update(tableName, _toMap(), where: "id = ?", whereArgs: [id]);

    _close();

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