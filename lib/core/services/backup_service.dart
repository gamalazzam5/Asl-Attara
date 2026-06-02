import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/tables/activity_log_table.dart';
import '../database/tables/category_table.dart';
import '../database/tables/inventory_log_table.dart';
import '../database/tables/product_table.dart';
import '../database/tables/sale_item_table.dart';
import '../database/tables/sale_table.dart';

class BackupService {
  final AppDatabase appDatabase;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  BackupService({
    required this.appDatabase,
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> get _userDocument {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null) throw const BackupUserNotFoundException();

    return firestore.collection('users').doc(uid);
  }

  Future<BackupMetadata?> getBackupMetadata() async {
    final snapshot = await _userDocument.get();
    final data = snapshot.data();
    if (data == null || data['sync'] == null) return null;

    return BackupMetadata.fromJson(data['sync'] as Map<String, dynamic>);
  }

  Future<BackupMetadata> uploadBackup() async {
    final db = await appDatabase.database;
    final now = DateTime.now();

    await db.insert(ActivityLogTable.tableName, {
      ActivityLogTable.action: 'sync_completed',
      ActivityLogTable.targetType: 'sync',
      ActivityLogTable.targetId: now.millisecondsSinceEpoch,
      ActivityLogTable.targetName: 'Firebase',
      ActivityLogTable.description: 'تمت مزامنة البيانات مع Firebase',
      ActivityLogTable.createdAt: now.millisecondsSinceEpoch,
    });

    final categories = await db.query(CategoryTable.tableName);
    final products = await db.query(ProductTable.tableName);
    final saleItems = await db.query(SaleItemTable.tableName);
    final sales = await _salesWithItems(db, saleItems);
    final inventoryLogs = await db.query(InventoryLogTable.tableName);
    final activities = await db.query(ActivityLogTable.tableName);

    await _replaceCollection(CategoryTable.tableName, categories);
    await _replaceCollection(ProductTable.tableName, products);
    await _replaceCollection(SaleTable.tableName, sales);
    await _replaceCollection(InventoryLogTable.tableName, inventoryLogs);
    await _replaceCollection(ActivityLogTable.tableName, activities);

    final metadata = BackupMetadata(
      uploadedAt: now,
      categoriesCount: categories.length,
      productsCount: products.length,
      salesCount: sales.length,
      inventoryLogsCount: inventoryLogs.length,
      activitiesCount: activities.length,
    );

    await _userDocument.set({
      'sync': metadata.toJson(),
    }, SetOptions(merge: true));

    return metadata;
  }

  Future<BackupMetadata> restoreBackup() async {
    final categories = await _readCollection(CategoryTable.tableName);
    final products = await _readCollection(ProductTable.tableName);
    final salesWithItems = await _readCollection(SaleTable.tableName);
    final sales = <Map<String, Object?>>[];
    final saleItems = <Map<String, Object?>>[];

    for (final sale in salesWithItems) {
      final items = sale['items'];
      final saleRow = Map<String, Object?>.from(sale)..remove('items');
      sales.add(saleRow);

      if (items is List) {
        for (final item in items) {
          if (item is Map) {
            saleItems.add(
              item.map((key, value) => MapEntry(key.toString(), value)),
            );
          }
        }
      }
    }
    final inventoryLogs = await _readCollection(InventoryLogTable.tableName);
    final activities = await _readCollection(ActivityLogTable.tableName);

    if (categories.isEmpty &&
        products.isEmpty &&
        sales.isEmpty &&
        inventoryLogs.isEmpty &&
        activities.isEmpty) {
      throw const BackupNotFoundException();
    }

    final db = await appDatabase.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      await txn.delete(SaleItemTable.tableName);
      await txn.delete(SaleTable.tableName);
      await txn.delete(InventoryLogTable.tableName);
      await txn.delete(ProductTable.tableName);
      await txn.delete(CategoryTable.tableName);
      await txn.delete(ActivityLogTable.tableName);

      await _insertRows(txn, CategoryTable.tableName, categories);
      await _insertRows(txn, ProductTable.tableName, products);
      await _insertRows(txn, SaleTable.tableName, sales);
      await _insertRows(txn, SaleItemTable.tableName, saleItems);
      await _insertRows(txn, InventoryLogTable.tableName, inventoryLogs);
      await _insertRows(txn, ActivityLogTable.tableName, activities);

      await txn.insert(ActivityLogTable.tableName, {
        ActivityLogTable.action: 'restore_completed',
        ActivityLogTable.targetType: 'restore',
        ActivityLogTable.targetId: now.millisecondsSinceEpoch,
        ActivityLogTable.targetName: 'Firebase',
        ActivityLogTable.description: 'تمت استعادة البيانات من Firebase',
        ActivityLogTable.createdAt: now.millisecondsSinceEpoch,
      });
    });

    final metadata = await getBackupMetadata();
    return metadata ??
        BackupMetadata(
          uploadedAt: now,
          categoriesCount: categories.length,
          productsCount: products.length,
          salesCount: sales.length,
          inventoryLogsCount: inventoryLogs.length,
          activitiesCount: activities.length,
        );
  }

  Future<void> _replaceCollection(
    String collectionName,
    List<Map<String, Object?>> rows,
  ) async {
    final collection = _userDocument.collection(collectionName);
    final existing = await collection.get();

    var batch = firestore.batch();
    var operations = 0;

    for (final doc in existing.docs) {
      batch.delete(doc.reference);
      operations++;
    }

    for (final row in rows) {
      final id = (row['id'] ?? row.hashCode).toString();
      batch.set(collection.doc(id), row);
      operations++;

      if (operations >= 450) {
        await batch.commit();
        batch = firestore.batch();
        operations = 0;
      }
    }

    if (operations > 0) {
      await batch.commit();
    }
  }

  Future<List<Map<String, Object?>>> _salesWithItems(
    Database db,
    List<Map<String, Object?>> saleItems,
  ) async {
    final sales = await db.query(SaleTable.tableName);

    return sales.map((sale) {
      final saleId = sale[SaleTable.id];
      final items = saleItems
          .where((item) => item[SaleItemTable.saleId] == saleId)
          .toList();

      return {...sale, 'items': items};
    }).toList();
  }

  Future<List<Map<String, Object?>>> _readCollection(
    String collectionName,
  ) async {
    final snapshot = await _userDocument.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      return doc.data().map((key, value) => MapEntry(key, value));
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
  final int salesCount;
  final int inventoryLogsCount;
  final int activitiesCount;

  const BackupMetadata({
    required this.uploadedAt,
    required this.categoriesCount,
    required this.productsCount,
    required this.salesCount,
    required this.inventoryLogsCount,
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
      salesCount: counts is Map ? (counts['sales'] as int? ?? 0) : 0,
      inventoryLogsCount: counts is Map
          ? (counts['inventory_logs'] as int? ?? 0)
          : 0,
      activitiesCount: counts is Map
          ? (counts['activity_logs'] as int? ?? 0)
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'counts': {
        'categories': categoriesCount,
        'products': productsCount,
        'sales': salesCount,
        'inventory_logs': inventoryLogsCount,
        'activity_logs': activitiesCount,
      },
    };
  }
}

class BackupNotFoundException implements Exception {
  const BackupNotFoundException();

  @override
  String toString() => 'No Firebase backup was found.';
}

class BackupUserNotFoundException implements Exception {
  const BackupUserNotFoundException();

  @override
  String toString() => 'No signed in user was found.';
}
