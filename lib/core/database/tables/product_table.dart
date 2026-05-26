import 'category_table.dart';

class ProductTable {
  static const tableName = 'products';

  static const id = 'id';
  static const name = 'name';
  static const quantity = 'quantity';
  static const unit = 'unit';
  static const minimumStockQuantity = 'minimumStockQuantity';
  static const categoryId = 'categoryId';
  static const categoryName = 'categoryName';
  static const buyPrice = 'buyPrice';
  static const sellPrice = 'sellPrice';

  static const createTable =
      '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY,
      $name TEXT NOT NULL UNIQUE,
      $quantity REAL NOT NULL,
      $unit TEXT NOT NULL,
      $minimumStockQuantity REAL NOT NULL,
      $categoryId INTEGER NOT NULL,
      $categoryName TEXT NOT NULL,
      $buyPrice REAL NOT NULL,
      $sellPrice REAL NOT NULL,
      FOREIGN KEY ($categoryId)
        REFERENCES ${CategoryTable.tableName} (${CategoryTable.id})
        ON UPDATE CASCADE
        ON DELETE RESTRICT
    )
  ''';
}
