import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'drug.dart';

const String tableName = "remainder";

class Remainder {

  int? id;
  late bool ingested;
  late DateTime date;
  Drug? drug;

  Remainder({ required this.ingested, required this.date });

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

    List<Remainder> remainders = [];
    for(int i = 0; i < maps.length; i++) {
      Remainder remainder = await Remainder.fromMap(maps[i]);
      remainders.add(remainder);
    }

    return remainders;

  }

  static Future<List<Remainder>?> getAll() async {

    Database db = await openDB();
    List<Map> maps = await db.query(tableName);
    db.close();

    List<Remainder> remainders = [];
    for(int i = 0; i < maps.length; i++) {
      Remainder remainder = await Remainder.fromMap(maps[i]);
      remainders.add(remainder);
    }

    return remainders;

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
    };
    if(drug != null) map["drug_id"] = drug?.id;
    if(id != null) map["id"] = id;
    return map;
  }

  static fromMap(Map<dynamic, dynamic> map) async {
    Remainder remainder = Remainder(ingested: (map["ingested"] as int) == 1, date: DateTime.parse(map["date"]));
    Drug? drug = await Drug.get(map["drug_id"]);
    remainder.id = map["id"] as int;
    if(drug != null) remainder.drug = drug;
    return remainder;
  }

}