class SaleTable {
  static const tableName = 'sales';

  static const id = 'id';
  static const totalAmount = 'totalAmount';
  static const totalProfit = 'totalProfit';
  static const createdAt = 'createdAt';

  static const createTable =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY,
      $totalAmount REAL NOT NULL,
      $totalProfit REAL NOT NULL,
      $createdAt INTEGER NOT NULL
    )
  ''';
}
