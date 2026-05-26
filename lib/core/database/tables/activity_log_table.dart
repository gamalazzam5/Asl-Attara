class ActivityLogTable {
  static const tableName = 'activity_logs';

  static const id = 'id';
  static const action = 'action';
  static const targetType = 'targetType';
  static const targetId = 'targetId';
  static const targetName = 'targetName';
  static const description = 'description';
  static const createdAt = 'createdAt';

  static const createTable =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $action TEXT NOT NULL,
      $targetType TEXT NOT NULL,
      $targetId INTEGER NOT NULL,
      $targetName TEXT NOT NULL,
      $description TEXT NOT NULL,
      $createdAt INTEGER NOT NULL
    )
  ''';
}
