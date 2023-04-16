import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'drug.dart';

const String tableName = "remainder";

class Remainder {

  int? id;
  late bool ingested;
  late DateTime date;
  late Drug drug;

  Remainder({ required this.ingested, required this.date, required this.drug });

  Future save() async {
    Database db = await openDB();
    id = await db.insert(tableName, _toMap());
    db.close();
  }

  static Future<List<Remainder>?> getActive() async {

    Database db = await openDB();

    List<Map> maps = await db.query(
        tableName,
        columns: ["id", "ingested", "date", "drug_id"],
        where: "ingested = ?",
        whereArgs: [0]
    );

    db.close();

    return maps.map((map) => Remainder.fromMap(map)).toList();

  }

  static Future<List<Remainder>?> getAll() async {
    Database db = await openDB();
    List<Map> maps = await db.query(tableName);
    db.close();
    return maps.map((map) => Remainder.fromMap(map)).toList();
  }

  static Future<Remainder?> get(int id) async {

    Database db = await openDB();

    List<Map> maps = await db.query(
        "SELECT * FROM " + tableName,
        columns: ["id", "ingested", "date", "drug_id"],
        where: "id = ?",
        whereArgs: [id]
    );

    db.close();

    return maps.map((map) => Remainder.fromMap(map)).toList().first;

  }

  Future delete() async {
    Database db = await openDB();
    if(id == null) throw Exception("Remainder id is null");
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Future update() async {
    Database db = await openDB();
    if(id == null) throw Exception("Remainder id is null");
    await db.update(tableName, _toMap(), where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Map<String, Object?> _toMap() {
    var map = <String, Object?> {
      "ingested": ingested ? 1 : 0,
      "date": date.toIso8601String(),
      "drug_id": drug.id,
    };
    if(id != null) map["id"] = id;
    return map;
  }

  Remainder.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    ingested = (map["ingested"] as int) == 1;
    date = DateTime.parse(map["date"]);
    Drug.get(map["drug_id"]).then((value) => drug = value!);
  }

}