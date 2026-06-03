import 'dart:io';

import 'package:aslattara/core/database/tables/category_table.dart';
import 'package:aslattara/core/database/tables/inventory_log_table.dart';
import 'package:aslattara/core/database/tables/product_table.dart';
import 'package:aslattara/core/database/tables/sale_item_table.dart';
import 'package:aslattara/core/database/tables/sale_table.dart';
import 'package:aslattara/core/services/backup_payload_normalizer.dart';

void main() {
  _checkExtraFieldsAreRemoved();
  _checkOldSaleItemsAreUpgraded();
  _checkCountMismatchIsRejected();
  _checkBrokenReferencesAreRejected();
  _checkConsistentGraphIsAccepted();

  stdout.writeln('Backup payload normalizer checks passed.');
}

void _checkExtraFieldsAreRemoved() {
  final row = BackupPayloadNormalizer.sanitizeRow(ProductTable.tableName, {
    ProductTable.id: 1,
    ProductTable.name: 'سبانخ',
    ProductTable.quantity: 2.5,
    ProductTable.unit: 'كجم',
    ProductTable.minimumStockQuantity: 1,
    ProductTable.categoryId: 1,
    ProductTable.categoryName: 'خضار',
    ProductTable.buyPrice: 20,
    ProductTable.sellPrice: 30,
    'syncedAt': 123,
    'quantityText': '2.5 كجم',
  });

  _expect(row != null, 'Expected sanitized product row.');
  _expect(!row!.containsKey('syncedAt'), 'syncedAt should be removed.');
  _expect(!row.containsKey('quantityText'), 'quantityText should be removed.');
  _expect(row[ProductTable.quantity] == 2.5, 'Quantity should be preserved.');
}

void _checkOldSaleItemsAreUpgraded() {
  final row = BackupPayloadNormalizer.sanitizeRow(SaleItemTable.tableName, {
    SaleItemTable.id: 1,
    SaleItemTable.saleId: 10,
    SaleItemTable.productId: 2,
    SaleItemTable.productName: 'ملوخية',
    SaleItemTable.quantity: 0.25,
    SaleItemTable.unit: 'كجم',
    SaleItemTable.buyPrice: 20,
    SaleItemTable.sellPrice: 40,
    SaleItemTable.totalAmount: 10,
    SaleItemTable.profit: 5,
  });

  _expect(row != null, 'Expected sanitized sale item row.');
  _expect(
    row![SaleItemTable.enteredAmount] == 10,
    'enteredAmount should fallback to totalAmount.',
  );
  _expect(
    row[SaleItemTable.calculatedQuantity] == 0.25,
    'calculatedQuantity should fallback to quantity.',
  );
}

void _checkCountMismatchIsRejected() {
  _expectThrowsBackupCorruption(
    () => BackupPayloadNormalizer.validateCounts(
      counts: const BackupCounts(
        categoriesCount: 1,
        productsCount: 1,
        salesCount: 1,
        inventoryLogsCount: 0,
        activitiesCount: 0,
      ),
      categories: [_category()],
      products: [_product()],
      sales: const [],
      inventoryLogs: const [],
      activities: const [],
    ),
    'Mismatched counts should be rejected.',
  );
}

void _checkBrokenReferencesAreRejected() {
  _expectThrowsBackupCorruption(
    () => BackupPayloadNormalizer.validateReferences(
      categories: [_category()],
      products: [_product()],
      sales: [_sale()],
      saleItems: [_saleItem(productId: 404)],
      inventoryLogs: const [],
    ),
    'Broken sale item product reference should be rejected.',
  );
}

void _checkConsistentGraphIsAccepted() {
  BackupPayloadNormalizer.validateReferences(
    categories: [_category()],
    products: [_product()],
    sales: [_sale()],
    saleItems: [_saleItem()],
    inventoryLogs: [_inventoryLog()],
  );
}

Map<String, Object?> _category() {
  return {
    CategoryTable.id: 1,
    CategoryTable.title: 'خضار',
    CategoryTable.imagePath: 'assets/images/greens.png',
    CategoryTable.backgroundColor: '#D4F1E4',
  };
}

Map<String, Object?> _product() {
  return {
    ProductTable.id: 2,
    ProductTable.name: 'ملوخية',
    ProductTable.quantity: 3,
    ProductTable.unit: 'كجم',
    ProductTable.minimumStockQuantity: 1,
    ProductTable.categoryId: 1,
    ProductTable.categoryName: 'خضار',
    ProductTable.buyPrice: 20,
    ProductTable.sellPrice: 40,
  };
}

Map<String, Object?> _sale() {
  return {
    SaleTable.id: 10,
    SaleTable.totalAmount: 10,
    SaleTable.totalProfit: 5,
    SaleTable.createdAt: 1000,
  };
}

Map<String, Object?> _saleItem({int productId = 2}) {
  return {
    SaleItemTable.id: 11,
    SaleItemTable.saleId: 10,
    SaleItemTable.productId: productId,
    SaleItemTable.productName: 'ملوخية',
    SaleItemTable.enteredAmount: 10,
    SaleItemTable.calculatedQuantity: 0.25,
    SaleItemTable.quantity: 0.25,
    SaleItemTable.unit: 'كجم',
    SaleItemTable.buyPrice: 20,
    SaleItemTable.sellPrice: 40,
    SaleItemTable.totalAmount: 10,
    SaleItemTable.profit: 5,
  };
}

Map<String, Object?> _inventoryLog() {
  return {
    InventoryLogTable.id: 20,
    InventoryLogTable.productId: 2,
    InventoryLogTable.productName: 'ملوخية',
    InventoryLogTable.changeQuantity: -0.25,
    InventoryLogTable.quantityBefore: 3,
    InventoryLogTable.quantityAfter: 2.75,
    InventoryLogTable.type: 'sale',
    InventoryLogTable.description: 'بيع 250 جرام من ملوخية',
    InventoryLogTable.createdAt: 1000,
  };
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void _expectThrowsBackupCorruption(void Function() action, String message) {
  try {
    action();
  } on BackupCorruptedException {
    return;
  }

  throw StateError(message);
}
