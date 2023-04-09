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

  await db.execute('''
    create table if not exists drug (
      id integer primary key autoincrement,
      name text not null,
      freq_type text not null,
      freq integer not null,
      start_hour time not null,
      days integer,
      duration text not null,
      indications text
    )
  ''');

  await db.execute('''
    create table if not exists remainder (
      id integer primary key autoincrement,
      ingested integer not null,
      date datetime not null,
      drug_id integer not null,
      foreign key(drug_id) references drug(id) on delete no action on update cascade
    )
  ''');

  return db;

}