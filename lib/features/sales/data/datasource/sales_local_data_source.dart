import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/activity_log_table.dart';
import '../../../../core/database/tables/inventory_log_table.dart';
import '../../../../core/database/tables/product_table.dart';
import '../../../../core/database/tables/sale_item_table.dart';
import '../../../../core/database/tables/sale_table.dart';
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
      final itemTotal = item.quantity * item.product.sellPrice;
      final itemProfit =
          item.quantity * (item.product.sellPrice - item.product.buyPrice);

      return SaleItemModel(
        id: saleId + item.product.id,
        saleId: saleId,
        productId: item.product.id,
        productName: item.product.name,
        quantity: item.quantity,
        unit: item.product.unit,
        buyPrice: item.product.buyPrice,
        sellPrice: item.product.sellPrice,
        totalAmount: itemTotal,
        profit: itemProfit,
      );
    }).toList();

    final sale = SaleModel(
      id: saleId,
      totalAmount: saleItems.fold(0, (sum, item) => sum + item.totalAmount),
      totalProfit: saleItems.fold(0, (sum, item) => sum + item.profit),
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

        if (item.quantity <= 0) {
          throw SaleValidationException(
            'كمية "${item.product.name}" غير صحيحة',
          );
        }

        if (item.quantity > currentQuantity) {
          throw SaleValidationException(
            'الكمية المطلوبة من "${item.product.name}" أكبر من المتاح',
          );
        }
      }

      await txn.insert(SaleTable.tableName, sale.toJson());

      for (final saleItem in saleItems) {
        await txn.insert(SaleItemTable.tableName, saleItem.toJson());

        final product = items
            .firstWhere((item) => item.product.id == saleItem.productId)
            .product;
        final quantityBefore = product.quantity;
        final quantityAfter = quantityBefore - saleItem.quantity;

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
          InventoryLogTable.changeQuantity: -saleItem.quantity,
          InventoryLogTable.quantityBefore: quantityBefore,
          InventoryLogTable.quantityAfter: quantityAfter,
          InventoryLogTable.type: 'sale',
          InventoryLogTable.description:
              'بيع ${saleItem.quantity} ${saleItem.unit} من ${saleItem.productName}',
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
