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
    List<Map> maps = await db.rawQuery("SELECT remainder.id as remainder_id, ingested, date, drug_id, name, freq_type, freq, start_hour, days, duration, indications, drug.id as id FROM remainder INNER JOIN drug ON drug.id = remainder.drug_id WHERE ingested = 0");
    maps.forEach((element) {print(element);});
    db.close();
    return maps.map((e) => Remainder.fromMap(e)).toList();
  }

  static Future<List<Remainder>?> getSamePeriodAndDrug(DateTime date, Drug drug) async {
    Database db = await openDB();
    List<Map> maps = await db.rawQuery("SELECT remainder.id as remainder_id, ingested, date, drug_id, name, freq_type, freq, start_hour, days, duration, indications, drug.id as id FROM remainder INNER JOIN drug ON drug.id = remainder.drug_id WHERE date = '" + date.toIso8601String() + "' AND drug_id = " + drug.id.toString());
    db.close();
    return maps.map((e) => Remainder.fromMap(e)).toList();
  }

  static Future<List<Remainder>?> getAll() async {
    Database db = await openDB();
    List<Map> maps = await db.rawQuery("SELECT remainder.id as remainder_id, ingested, date, drug_id, name, freq_type, freq, start_hour, days, duration, indications, drug.id as id FROM remainder INNER JOIN drug ON drug.id = remainder.drug_id");
    db.close();
    return maps.map((e) => Remainder.fromMap(e)).toList();
  }

  static Future<Remainder?> get(int id) async {
    Database db = await openDB();
    List<Map> maps = await db.rawQuery("SELECT remainder.id as remainder_id, ingested, date, drug_id, name, freq_type, freq, start_hour, days, duration, indications, drug.id as id FROM remainder INNER JOIN drug ON drug.id = remainder.drug_id WHERE remainder.id = " + id.toString());
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
    map["drug_id"] = drug.id;
    if(id != null) map["id"] = id;
    return map;
  }

  Remainder.fromMap(Map<dynamic, dynamic> map) {
    Drug tempDrug = Drug.fromMap(map);
    ingested = (map["ingested"] as int) == 1;
    date = DateTime.parse(map["date"]);
    drug = tempDrug;
    if(map["remainder_id"] != null) id = map["remainder_id"] as int;
  }

}