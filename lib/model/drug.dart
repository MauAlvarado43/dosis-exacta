import 'package:dosis_exacta/model/database.dart';
import 'package:dosis_exacta/model/remainder.dart';
import 'package:dosis_exacta/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "drug";

class Drug {

  int? id;
  late String name;
  late FREQ_TYPE freq_type;
  late int freq;
  late int start_hour;
  int? days;
  late DURATION duration;
  late String? indications;

  Drug({ required this.name, required this.freq_type, required this.freq, required this.start_hour, required this.duration });

  Future save() async {
    Database db = await openDB();
    id = await db.insert(tableName, _toMap());
    db.close();
  }

  static Future<List<Drug>?> getAll() async {
    Database db = await openDB();
    List<Map> maps = await db.query(tableName);
    db.close();
    return maps.map((map) => Drug.fromMap(map)).toList(); //the error is here
  }

  static Future<Drug?> get(int id) async {

    Database db = await openDB();

    List<Map> maps = await db.query(
        tableName,
        columns: ["id", "name", "freq_type", "freq", "start_hour", "days", "duration", "indications"],
        where: "id = ?",
        whereArgs: [id]
    );

    db.close();

    if(maps.isEmpty) return null;
    return maps.map((map) => Drug.fromMap(map)).toList().first;

  }

  Future delete() async {
    Database db = await openDB();
    if(id == null) throw Exception("Drug id is null");
    print(id);
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    await Remainder.deleteByDrugId(id!);
    db.close();
  }

  Future update() async {
    Database db = await openDB();
    if(id == null) throw Exception("Drug id is null");
    await db.update(tableName, _toMap(), where: "id = ?", whereArgs: [id]);
    db.close();
  }

  Map<String, Object?> _toMap() {
    var map = <String, Object?> {
      "name": name,
      "freq_type": freq_type.name,
      "freq": freq,
      "start_hour": start_hour,
      "days": days,
      "duration": duration.name,
      "indications": indications
    };
    if(id != null) map["id"] = id;
    return map;
  }

  Drug.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    freq_type = freqFromString(map["freq_type"]);
    freq = map["freq"] as int;
    start_hour = map["start_hour"] as int;
    days = map["days"] as int?;
    duration = durationFromString(map["duration"]);
    indications = map["indications"] as String?;
  }

}