import '../database/tables/activity_log_table.dart';
import '../database/tables/category_table.dart';
import '../database/tables/inventory_log_table.dart';
import '../database/tables/product_table.dart';
import '../database/tables/sale_item_table.dart';
import '../database/tables/sale_table.dart';

class BackupPayloadNormalizer {
  const BackupPayloadNormalizer._();

  static List<Map<String, Object?>> sanitizeRows({
    required String tableName,
    required List<Map<String, Object?>> rows,
  }) {
    return rows
        .map((row) => sanitizeRow(tableName, row))
        .whereType<Map<String, Object?>>()
        .toList();
  }

  static Map<String, Object?>? sanitizeRow(
    String tableName,
    Map<String, Object?> row,
  ) {
    final allowedColumns = tableColumns[tableName];
    final requiredColumns = requiredColumnsByTable[tableName];
    if (allowedColumns == null || requiredColumns == null) {
      throw BackupCorruptedException('Unknown backup table "$tableName".');
    }

    final sanitized = <String, Object?>{};
    for (final column in allowedColumns) {
      if (row.containsKey(column)) {
        sanitized[column] = row[column];
      }
    }

    if (tableName == SaleItemTable.tableName) {
      sanitized[SaleItemTable.enteredAmount] ??=
          sanitized[SaleItemTable.totalAmount];
      sanitized[SaleItemTable.calculatedQuantity] ??=
          sanitized[SaleItemTable.quantity];
    }

    for (final column in requiredColumns) {
      final value = sanitized[column];
      if (value == null || (value is String && value.trim().isEmpty)) {
        return null;
      }
    }

    return sanitized;
  }

  static void validateCounts({
    required BackupCounts counts,
    required List<Map<String, Object?>> categories,
    required List<Map<String, Object?>> products,
    required List<Map<String, Object?>> sales,
    required List<Map<String, Object?>> inventoryLogs,
    required List<Map<String, Object?>> activities,
  }) {
    final hasMismatchedCounts =
        categories.length != counts.categoriesCount ||
        products.length != counts.productsCount ||
        sales.length != counts.salesCount ||
        inventoryLogs.length != counts.inventoryLogsCount ||
        activities.length != counts.activitiesCount;

    if (hasMismatchedCounts) {
      throw const BackupCorruptedException(
        'Backup row counts do not match metadata.',
      );
    }
  }

  static void validateReferences({
    required List<Map<String, Object?>> categories,
    required List<Map<String, Object?>> products,
    required List<Map<String, Object?>> sales,
    required List<Map<String, Object?>> saleItems,
    required List<Map<String, Object?>> inventoryLogs,
  }) {
    final categoryIds = categories.map((row) => row[CategoryTable.id]).toSet();
    final productIds = products.map((row) => row[ProductTable.id]).toSet();
    final saleIds = sales.map((row) => row[SaleTable.id]).toSet();

    final missingProductCategory = products.any(
      (row) => !categoryIds.contains(row[ProductTable.categoryId]),
    );
    final missingSaleItemProduct = saleItems.any(
      (row) => !productIds.contains(row[SaleItemTable.productId]),
    );
    final missingSaleItemSale = saleItems.any(
      (row) => !saleIds.contains(row[SaleItemTable.saleId]),
    );
    final missingMovementProduct = inventoryLogs.any(
      (row) => !productIds.contains(row[InventoryLogTable.productId]),
    );

    if (missingProductCategory ||
        missingSaleItemProduct ||
        missingSaleItemSale ||
        missingMovementProduct) {
      throw const BackupCorruptedException(
        'Backup contains rows with broken references.',
      );
    }
  }

  static const Map<String, Set<String>> tableColumns = {
    CategoryTable.tableName: {
      CategoryTable.id,
      CategoryTable.title,
      CategoryTable.imagePath,
      CategoryTable.backgroundColor,
    },
    ProductTable.tableName: {
      ProductTable.id,
      ProductTable.name,
      ProductTable.quantity,
      ProductTable.unit,
      ProductTable.minimumStockQuantity,
      ProductTable.categoryId,
      ProductTable.categoryName,
      ProductTable.buyPrice,
      ProductTable.sellPrice,
    },
    SaleTable.tableName: {
      SaleTable.id,
      SaleTable.totalAmount,
      SaleTable.totalProfit,
      SaleTable.createdAt,
    },
    SaleItemTable.tableName: {
      SaleItemTable.id,
      SaleItemTable.saleId,
      SaleItemTable.productId,
      SaleItemTable.productName,
      SaleItemTable.enteredAmount,
      SaleItemTable.calculatedQuantity,
      SaleItemTable.quantity,
      SaleItemTable.unit,
      SaleItemTable.buyPrice,
      SaleItemTable.sellPrice,
      SaleItemTable.totalAmount,
      SaleItemTable.profit,
    },
    InventoryLogTable.tableName: {
      InventoryLogTable.id,
      InventoryLogTable.productId,
      InventoryLogTable.productName,
      InventoryLogTable.changeQuantity,
      InventoryLogTable.quantityBefore,
      InventoryLogTable.quantityAfter,
      InventoryLogTable.type,
      InventoryLogTable.description,
      InventoryLogTable.createdAt,
    },
    ActivityLogTable.tableName: {
      ActivityLogTable.id,
      ActivityLogTable.action,
      ActivityLogTable.targetType,
      ActivityLogTable.targetId,
      ActivityLogTable.targetName,
      ActivityLogTable.description,
      ActivityLogTable.createdAt,
    },
  };

  static const Map<String, Set<String>> requiredColumnsByTable = {
    CategoryTable.tableName: {
      CategoryTable.id,
      CategoryTable.title,
      CategoryTable.imagePath,
      CategoryTable.backgroundColor,
    },
    ProductTable.tableName: {
      ProductTable.id,
      ProductTable.name,
      ProductTable.quantity,
      ProductTable.unit,
      ProductTable.minimumStockQuantity,
      ProductTable.categoryId,
      ProductTable.categoryName,
      ProductTable.buyPrice,
      ProductTable.sellPrice,
    },
    SaleTable.tableName: {
      SaleTable.id,
      SaleTable.totalAmount,
      SaleTable.totalProfit,
      SaleTable.createdAt,
    },
    SaleItemTable.tableName: {
      SaleItemTable.id,
      SaleItemTable.saleId,
      SaleItemTable.productId,
      SaleItemTable.productName,
      SaleItemTable.quantity,
      SaleItemTable.unit,
      SaleItemTable.buyPrice,
      SaleItemTable.sellPrice,
      SaleItemTable.totalAmount,
      SaleItemTable.profit,
    },
    InventoryLogTable.tableName: {
      InventoryLogTable.id,
      InventoryLogTable.productId,
      InventoryLogTable.productName,
      InventoryLogTable.changeQuantity,
      InventoryLogTable.quantityBefore,
      InventoryLogTable.quantityAfter,
      InventoryLogTable.type,
      InventoryLogTable.description,
      InventoryLogTable.createdAt,
    },
    ActivityLogTable.tableName: {
      ActivityLogTable.action,
      ActivityLogTable.targetType,
      ActivityLogTable.targetId,
      ActivityLogTable.targetName,
      ActivityLogTable.description,
      ActivityLogTable.createdAt,
    },
  };
}

class BackupCounts {
  final int categoriesCount;
  final int productsCount;
  final int salesCount;
  final int inventoryLogsCount;
  final int activitiesCount;

  const BackupCounts({
    required this.categoriesCount,
    required this.productsCount,
    required this.salesCount,
    required this.inventoryLogsCount,
    required this.activitiesCount,
  });
}

class BackupCorruptedException implements Exception {
  final String message;

  const BackupCorruptedException(this.message);

  @override
  String toString() => message;
}
