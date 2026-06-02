import 'product_table.dart';

class InventoryLogTable {
  static const tableName = 'inventory_logs';

  static const id = 'id';
  static const productId = 'productId';
  static const productName = 'productName';
  static const changeQuantity = 'changeQuantity';
  static const quantityBefore = 'quantityBefore';
  static const quantityAfter = 'quantityAfter';
  static const type = 'type';
  static const description = 'description';
  static const createdAt = 'createdAt';

  static const createTable =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY,
      $productId INTEGER NOT NULL,
      $productName TEXT NOT NULL,
      $changeQuantity REAL NOT NULL,
      $quantityBefore REAL NOT NULL,
      $quantityAfter REAL NOT NULL,
      $type TEXT NOT NULL,
      $description TEXT NOT NULL,
      $createdAt INTEGER NOT NULL,
      FOREIGN KEY ($productId)
        REFERENCES ${ProductTable.tableName} (${ProductTable.id})
        ON UPDATE CASCADE
        ON DELETE RESTRICT
    )
  ''';
}
