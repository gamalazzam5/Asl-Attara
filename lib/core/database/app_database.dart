import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/activity_log_table.dart';
import 'tables/category_table.dart';
import 'tables/inventory_log_table.dart';
import 'tables/product_table.dart';
import 'tables/sale_item_table.dart';
import 'tables/sale_table.dart';

class AppDatabase {
  static const _defaultDatabaseName = 'aslattara.db';
  static const _databaseVersion = 5;

  final String databaseName;
  Database? _database;
  String? _openedDatabaseName;

  AppDatabase({this.databaseName = _defaultDatabaseName});

  Future<Database> get database async {
    final activeDatabaseName = _activeDatabaseName;

    if (_database != null && _openedDatabaseName == activeDatabaseName) {
      return _database!;
    }

    await close();

    _database = await _openDatabase();
    _openedDatabaseName = activeDatabaseName;

    return _database!;
  }

  String get _activeDatabaseName {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return databaseName;

    final safeUid = uid.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return 'aslattara_$safeUid.db';
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, _activeDatabaseName);

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
        await db.execute(SaleTable.createTable);
        await db.execute(SaleItemTable.createTable);
        await db.execute(InventoryLogTable.createTable);
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

        if (oldVersion < 5) {
          await db.execute(SaleTable.createTable);
          await db.execute(SaleItemTable.createTable);
          await db.execute(InventoryLogTable.createTable);
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
    _openedDatabaseName = null;
  }
}
