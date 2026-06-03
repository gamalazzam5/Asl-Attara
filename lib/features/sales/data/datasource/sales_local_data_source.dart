import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/activity_log_table.dart';
import '../../../../core/database/tables/inventory_log_table.dart';
import '../../../../core/database/tables/product_table.dart';
import '../../../../core/database/tables/sale_item_table.dart';
import '../../../../core/database/tables/sale_table.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../domain/repositories/sales_repository.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';

class SalesLocalDataSource {
  final AppDatabase appDatabase;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  SalesLocalDataSource(
    this.appDatabase, {
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<SaleModel> createSale(List<SaleDraftItem> items) async {
    final db = await appDatabase.database;
    final now = DateTime.now();
    final saleId = now.microsecondsSinceEpoch;

    final saleItems = items.map((item) {
      final itemProfit =
          item.calculatedQuantity *
          (item.product.sellPrice - item.product.buyPrice);

      return SaleItemModel(
        id: saleId + item.product.id,
        saleId: saleId,
        productId: item.product.id,
        productName: item.product.name,
        enteredAmount: item.enteredAmount,
        calculatedQuantity: item.calculatedQuantity,
        quantity: item.calculatedQuantity,
        unit: item.product.unit,
        buyPrice: item.product.buyPrice,
        sellPrice: item.product.sellPrice,
        totalAmount: item.enteredAmount,
        profit: itemProfit,
      );
    }).toList();

    final sale = SaleModel(
      id: saleId,
      totalAmount: saleItems.fold(
        0,
        (total, item) => total + item.enteredAmount,
      ),
      totalProfit: saleItems.fold(0, (total, item) => total + item.profit),
      createdAt: now,
      items: saleItems,
    );

    final inventoryLogs = <Map<String, Object?>>[];
    late final Map<String, Object?> activityLog;
    final productUpdates = <int, double>{};

    await db.transaction((txn) async {
      for (final item in items) {
        final productRows = await txn.query(
          ProductTable.tableName,
          where: '${ProductTable.id} = ?',
          whereArgs: [item.product.id],
          limit: 1,
        );

        if (productRows.isEmpty) {
          throw SaleValidationException(
            'المنتج "${item.product.name}" غير موجود',
          );
        }

        final currentQuantity =
            (productRows.first[ProductTable.quantity] as num).toDouble();

        if (item.enteredAmount <= 0 || item.calculatedQuantity <= 0) {
          throw SaleValidationException(
            'بيانات البيع غير صحيحة للمنتج "${item.product.name}"',
          );
        }

        if (item.product.sellPrice <= 0) {
          throw SaleValidationException(
            'سعر البيع غير صحيح للمنتج "${item.product.name}"',
          );
        }

        if (item.calculatedQuantity > currentQuantity) {
          throw const SaleValidationException(
            'الكمية المطلوبة أكبر من المخزون المتاح',
          );
        }
      }

      await txn.insert(SaleTable.tableName, sale.toJson());

      for (final saleItem in saleItems) {
        await txn.insert(SaleItemTable.tableName, saleItem.toJson());

        final productRows = await txn.query(
          ProductTable.tableName,
          columns: [ProductTable.quantity],
          where: '${ProductTable.id} = ?',
          whereArgs: [saleItem.productId],
          limit: 1,
        );
        final quantityBefore = (productRows.first[ProductTable.quantity] as num)
            .toDouble();
        final quantityAfter = quantityBefore - saleItem.calculatedQuantity;

        await txn.update(
          ProductTable.tableName,
          {ProductTable.quantity: quantityAfter},
          where: '${ProductTable.id} = ?',
          whereArgs: [saleItem.productId],
        );

        productUpdates[saleItem.productId] = quantityAfter;

        final inventoryLog = {
          InventoryLogTable.id: saleId + saleItem.productId + 1000,
          InventoryLogTable.productId: saleItem.productId,
          InventoryLogTable.productName: saleItem.productName,
          InventoryLogTable.changeQuantity: -saleItem.calculatedQuantity,
          InventoryLogTable.quantityBefore: quantityBefore,
          InventoryLogTable.quantityAfter: quantityAfter,
          InventoryLogTable.type: 'sale',
          InventoryLogTable.description:
              'بيع ${QuantityFormatter.format(saleItem.calculatedQuantity, saleItem.unit)} من ${saleItem.productName}',
          InventoryLogTable.createdAt: now.millisecondsSinceEpoch,
        };

        await txn.insert(InventoryLogTable.tableName, inventoryLog);
        inventoryLogs.add(inventoryLog);
      }

      activityLog = {
        ActivityLogTable.action: 'sale_created',
        ActivityLogTable.targetType: 'sale',
        ActivityLogTable.targetId: sale.id,
        ActivityLogTable.targetName: 'عملية بيع',
        ActivityLogTable.description:
            'تم تسجيل عملية بيع بإجمالي ${sale.totalAmount.toStringAsFixed(2)} جنيه',
        ActivityLogTable.createdAt: now.millisecondsSinceEpoch,
      };

      await txn.insert(ActivityLogTable.tableName, activityLog);
    });

    await _syncSaleToFirestore(
      sale: sale,
      inventoryLogs: inventoryLogs,
      activityLog: activityLog,
      productUpdates: productUpdates,
    );

    return sale;
  }

  Future<List<SaleModel>> getSales() async {
    final db = await appDatabase.database;
    final saleRows = await db.query(
      SaleTable.tableName,
      orderBy: '${SaleTable.createdAt} DESC',
    );

    final sales = <SaleModel>[];
    for (final saleRow in saleRows) {
      final itemRows = await db.query(
        SaleItemTable.tableName,
        where: '${SaleItemTable.saleId} = ?',
        whereArgs: [saleRow[SaleTable.id]],
      );
      sales.add(
        SaleModel.fromJson(
          saleRow,
          items: itemRows.map(SaleItemModel.fromJson).toList(),
        ),
      );
    }

    return sales;
  }

  Future<double> sumToday(String column) async {
    final db = await appDatabase.database;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final result = await db.rawQuery(
      '''
      SELECT SUM($column) AS total
      FROM ${SaleTable.tableName}
      WHERE ${SaleTable.createdAt} >= ?
        AND ${SaleTable.createdAt} < ?
      ''',
      [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0;
  }

  Future<void> _syncSaleToFirestore({
    required SaleModel sale,
    required List<Map<String, Object?>> inventoryLogs,
    required Map<String, Object?> activityLog,
    required Map<int, double> productUpdates,
  }) async {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final userDocument = firestore.collection('users').doc(uid);
    final batch = firestore.batch();

    batch.set(userDocument.collection('sales').doc(sale.id.toString()), {
      ...sale.toJson(),
      'items': sale.items.map((item) {
        final saleItem = item as SaleItemModel;
        return {
          'productId': saleItem.productId,
          'productName': saleItem.productName,
          'enteredAmount': saleItem.enteredAmount,
          'calculatedQuantity': saleItem.calculatedQuantity,
          'calculatedQuantityText': QuantityFormatter.format(
            saleItem.calculatedQuantity,
            saleItem.unit,
          ),
          'unit': saleItem.unit,
          'sellPrice': saleItem.sellPrice,
          'createdAt': sale.createdAt.millisecondsSinceEpoch,
        };
      }).toList(),
      'syncedAt': DateTime.now().millisecondsSinceEpoch,
    });

    for (final saleItem in sale.items.cast<SaleItemModel>()) {
      batch.set(
        userDocument.collection('sale_items').doc(saleItem.id.toString()),
        saleItem.toJson(),
      );
    }

    for (final log in inventoryLogs) {
      final unit = sale.items
          .cast<SaleItemModel>()
          .firstWhere(
            (item) => item.productId == log[InventoryLogTable.productId],
          )
          .unit;

      batch.set(
        userDocument
            .collection('inventory_logs')
            .doc(log[InventoryLogTable.id].toString()),
        {
          ...log,
          'changeQuantityText': QuantityFormatter.format(
            log[InventoryLogTable.changeQuantity] as double,
            unit,
            includeSign: true,
          ),
          'quantityBeforeText': QuantityFormatter.format(
            log[InventoryLogTable.quantityBefore] as double,
            unit,
          ),
          'quantityAfterText': QuantityFormatter.format(
            log[InventoryLogTable.quantityAfter] as double,
            unit,
          ),
        },
      );
    }

    batch.set(
      userDocument
          .collection('activity_logs')
          .doc('${activityLog[ActivityLogTable.targetId]}_sale_created'),
      activityLog,
    );

    for (final update in productUpdates.entries) {
      batch.set(
        userDocument.collection('products').doc(update.key.toString()),
        {ProductTable.quantity: update.value},
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }
}

class SaleValidationException implements Exception {
  final String message;

  const SaleValidationException(this.message);

  @override
  String toString() => message;
}
