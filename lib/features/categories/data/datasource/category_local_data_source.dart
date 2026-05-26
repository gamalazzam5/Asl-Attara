import '../../../../core/database/app_database.dart';

import '../../../../core/database/tables/category_table.dart';

import '../../../../core/database/tables/product_table.dart';

import '../models/category_model.dart';

class CategoryLocalDataSource {
  final AppDatabase appDatabase;

  CategoryLocalDataSource(this.appDatabase);

  Future<List<CategoryModel>> getCategories() async {
    final db = await appDatabase.database;

    final result = await db.rawQuery('''
      SELECT
        c.${CategoryTable.id},
        c.${CategoryTable.title},
        c.${CategoryTable.imagePath},
        c.${CategoryTable.backgroundColor},
        COUNT(p.${ProductTable.id}) AS itemCount
      FROM ${CategoryTable.tableName} c
      LEFT JOIN ${ProductTable.tableName} p
        ON c.${CategoryTable.id} = p.${ProductTable.categoryId}
      GROUP BY c.${CategoryTable.id}
      ORDER BY c.${CategoryTable.id} ASC
    ''');

    return result.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    final db = await appDatabase.database;

    await db.insert(CategoryTable.tableName, category.toDatabaseJson());
  }

  Future<void> deleteCategory(int id) async {
    final db = await appDatabase.database;

    await db.delete(
      CategoryTable.tableName,
      where: '${CategoryTable.id} = ?',
      whereArgs: [id],
    );
  }
}
