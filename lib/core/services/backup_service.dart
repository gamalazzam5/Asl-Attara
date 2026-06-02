import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/tables/activity_log_table.dart';
import '../database/tables/category_table.dart';
import '../database/tables/product_table.dart';

class BackupService {
  static const _collectionPath = 'backups';
  static const _documentId = 'main_database';

  final AppDatabase appDatabase;
  final FirebaseFirestore firestore;

  BackupService({required this.appDatabase, FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _backupDocument =>
      firestore.collection(_collectionPath).doc(_documentId);

  Future<BackupMetadata?> getBackupMetadata() async {
    final snapshot = await _backupDocument.get();

    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    return BackupMetadata.fromJson(data);
  }

  Future<BackupMetadata> uploadBackup() async {
    final db = await appDatabase.database;
    final categories = await db.query(CategoryTable.tableName);
    final products = await db.query(ProductTable.tableName);
    final activities = await db.query(ActivityLogTable.tableName);
    final now = DateTime.now();

    final payload = <String, dynamic>{
      'schemaVersion': 1,
      'uploadedAt': Timestamp.fromDate(now),
      'counts': {
        'categories': categories.length,
        'products': products.length,
        'activities': activities.length,
      },
      'tables': {
        CategoryTable.tableName: categories,
        ProductTable.tableName: products,
        ActivityLogTable.tableName: activities,
      },
    };

    await _backupDocument.set(payload);

    return BackupMetadata(
      uploadedAt: now,
      categoriesCount: categories.length,
      productsCount: products.length,
      activitiesCount: activities.length,
    );
  }

  Future<BackupMetadata> restoreBackup() async {
    final snapshot = await _backupDocument.get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw const BackupNotFoundException();
    }

    final data = snapshot.data()!;
    final tables = data['tables'];

    if (tables is! Map<String, dynamic>) {
      throw const BackupFormatException();
    }

    final categories = _readRows(tables, CategoryTable.tableName);
    final products = _readRows(tables, ProductTable.tableName);
    final activities = _readRows(tables, ActivityLogTable.tableName);

    final db = await appDatabase.database;

    await db.transaction((txn) async {
      await txn.delete(ProductTable.tableName);
      await txn.delete(CategoryTable.tableName);
      await txn.delete(ActivityLogTable.tableName);

      await _insertRows(txn, CategoryTable.tableName, categories);
      await _insertRows(txn, ProductTable.tableName, products);
      await _insertRows(txn, ActivityLogTable.tableName, activities);
    });

    return BackupMetadata.fromJson(data);
  }

  List<Map<String, Object?>> _readRows(
    Map<String, dynamic> tables,
    String tableName,
  ) {
    final rows = tables[tableName];

    if (rows == null) return const [];
    if (rows is! List) throw const BackupFormatException();

    return rows.map((row) {
      if (row is! Map) throw const BackupFormatException();

      return row.map((key, value) => MapEntry(key.toString(), value));
    }).toList();
  }

  Future<void> _insertRows(
    Transaction txn,
    String tableName,
    List<Map<String, Object?>> rows,
  ) async {
    for (final row in rows) {
      await txn.insert(
        tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}

class BackupMetadata {
  final DateTime uploadedAt;
  final int categoriesCount;
  final int productsCount;
  final int activitiesCount;

  const BackupMetadata({
    required this.uploadedAt,
    required this.categoriesCount,
    required this.productsCount,
    required this.activitiesCount,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    final counts = json['counts'];
    final uploadedAtValue = json['uploadedAt'];

    return BackupMetadata(
      uploadedAt: uploadedAtValue is Timestamp
          ? uploadedAtValue.toDate()
          : DateTime.now(),
      categoriesCount: counts is Map ? (counts['categories'] as int? ?? 0) : 0,
      productsCount: counts is Map ? (counts['products'] as int? ?? 0) : 0,
      activitiesCount: counts is Map ? (counts['activities'] as int? ?? 0) : 0,
    );
  }
}

class BackupNotFoundException implements Exception {
  const BackupNotFoundException();

  @override
  String toString() => 'No Firebase backup was found.';
}

class BackupFormatException implements Exception {
  const BackupFormatException();

  @override
  String toString() => 'The Firebase backup has an invalid format.';
}
