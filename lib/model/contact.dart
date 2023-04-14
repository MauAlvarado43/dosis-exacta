import 'package:dosis_exacta/model/database.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "contact";

class Contact {

  int? id;
  late String name;
  late String email;
  late String phone;

  Contact({ required this.name, required this.email, required this.phone });

  Future save() async {
    Database db = await openDB();
    id = await db.insert(tableName, _toMap());
    db.close();
  }

  static Future<List<Contact>?> getAll() async {
    Database db = await openDB();
    List<Map> maps = await db.query(tableName);
    db.close();
    print(maps);
    //print(maps.map((map) => Contact.fromMap(map)).toList());
    return maps.map((map) => Contact.fromMap(map)).toList();
  }

  static Future<Contact?> get(int id) async {

    Database db = await openDB();

    List<Map> maps = await db.query(
        "SELECT * FROM " + tableName,
        columns: ["id", "name"],
        where: "id = ?",
        whereArgs: [id]
    );

    db.close();

    return maps.map((map) => Contact.fromMap(map)).toList().first;

  }

  Future delete() async {
    Database db = await openDB();
    if(id == null) throw Exception("Contact id is null");
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Future update() async {
    Database db = await openDB();
    if(id == null) throw Exception("Contact id is null");
    await db.update(tableName, _toMap(), where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Map<String, Object?> _toMap() {
    var map = <String, Object?> {
      "name": name,
      "email": email,
      "phone": phone
    };
    if(id != null) map["id"] = id;
    return map;
  }

  Contact.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    email = map["email"] as String;
    phone = map["phone"] as String;
  }

}