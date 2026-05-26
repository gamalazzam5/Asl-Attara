class CategoryTable {
  static const tableName = 'categories';

  static const id = 'id';
  static const title = 'title';
  static const imagePath = 'imagePath';
  static const backgroundColor = 'backgroundColor';

  static const createTable =
      '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY,
      $title TEXT NOT NULL UNIQUE,
      $imagePath TEXT NOT NULL,
      $backgroundColor TEXT NOT NULL
    )
  ''';
}
