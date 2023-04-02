import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDB() async {

  String path = await getDatabasesPath();
  Database db = await openDatabase(join(path, 'dosis_exacta.db'));

  await db.execute('''
    create table if not exists contact ( 
      id integer primary key autoincrement, 
      name text not null,
      email text not null,
      phone text not null
    )
  ''');

  await db.execute('''
    create table if not exists user ( 
      id integer primary key autoincrement, 
      name text not null
    )
  ''');

  return db;

}