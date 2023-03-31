import 'package:sqflite/sqflite.dart';

dynamic getDatabase() async {

  Database db = await openDatabase(''
      'dosis_exacta.db',
      version: 1,
      onCreate: (Database db, int version) async {

        // await db.execute();

      }
  );

  // TODO: Implement database

  return db;

}