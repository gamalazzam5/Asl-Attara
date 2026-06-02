import 'product_table.dart';
import 'sale_table.dart';

class SaleItemTable {
  static const tableName = 'sale_items';

  static const id = 'id';
  static const saleId = 'saleId';
  static const productId = 'productId';
  static const productName = 'productName';
  static const quantity = 'quantity';
  static const unit = 'unit';
  static const buyPrice = 'buyPrice';
  static const sellPrice = 'sellPrice';
  static const totalAmount = 'totalAmount';
  static const profit = 'profit';

  static const createTable =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY,
      $saleId INTEGER NOT NULL,
      $productId INTEGER NOT NULL,
      $productName TEXT NOT NULL,
      $quantity REAL NOT NULL,
      $unit TEXT NOT NULL,
      $buyPrice REAL NOT NULL,
      $sellPrice REAL NOT NULL,
      $totalAmount REAL NOT NULL,
      $profit REAL NOT NULL,
      FOREIGN KEY ($saleId)
        REFERENCES ${SaleTable.tableName} (${SaleTable.id})
        ON DELETE CASCADE,
      FOREIGN KEY ($productId)
        REFERENCES ${ProductTable.tableName} (${ProductTable.id})
        ON UPDATE CASCADE
        ON DELETE RESTRICT
    )
  ''';
}
