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

  SalesLocalDataSource(this.appDatabase);

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

        await txn.insert(InventoryLogTable.tableName, {
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
        });
      }

      await txn.insert(ActivityLogTable.tableName, {
        ActivityLogTable.action: 'sale_created',
        ActivityLogTable.targetType: 'sale',
        ActivityLogTable.targetId: sale.id,
        ActivityLogTable.targetName: 'عملية بيع',
        ActivityLogTable.description:
            'تم تسجيل عملية بيع بإجمالي ${sale.totalAmount.toStringAsFixed(2)} جنيه',
        ActivityLogTable.createdAt: now.millisecondsSinceEpoch,
      });
    });

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
}

class SaleValidationException implements Exception {
  final String message;

  const SaleValidationException(this.message);

  @override
  String toString() => message;
}
