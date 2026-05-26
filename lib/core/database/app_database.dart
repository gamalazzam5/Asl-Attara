import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/activity_log_table.dart';
import 'tables/category_table.dart';
import 'tables/product_table.dart';

class AppDatabase {
  static const _defaultDatabaseName = 'aslattara.db';
  static const _databaseVersion = 4;

  final String databaseName;
  Database? _database;

  AppDatabase({this.databaseName = _defaultDatabaseName});

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _openDatabase();

    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(CategoryTable.createTable);
        await db.execute(ProductTable.createTable);
        await db.execute(ActivityLogTable.createTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _removeSeedProducts(db);
        }

        if (oldVersion < 3) {
          await _removeSeedProducts(db);
          await _removeSeedCategories(db);
        }

        if (oldVersion < 4) {
          await db.execute(ActivityLogTable.createTable);
        }
      },
    );
  }

  Future<void> _removeSeedProducts(Database db) async {
    await db.delete(
      ProductTable.tableName,
      where:
          '''
        (${ProductTable.id} = ? AND ${ProductTable.name} = ?)
        OR (${ProductTable.id} = ? AND ${ProductTable.name} = ?)
      ''',
      whereArgs: [1, 'زعتر جاف', 2, 'زيت زيتون'],
    );
  }

  Future<void> _removeSeedCategories(Database db) async {
    await db.delete(
      CategoryTable.tableName,
      where:
          '''
        (
          (${CategoryTable.id} = ? AND ${CategoryTable.title} = ?)
          OR (${CategoryTable.id} = ? AND ${CategoryTable.title} = ?)
          OR (${CategoryTable.id} = ? AND ${CategoryTable.title} = ?)
        )
        AND NOT EXISTS (
          SELECT 1
          FROM ${ProductTable.tableName}
          WHERE ${ProductTable.categoryId} = ${CategoryTable.tableName}.${CategoryTable.id}
        )
      ''',
      whereArgs: [1, 'أعشاب', 2, 'بهارات', 3, 'زيوت'],
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
