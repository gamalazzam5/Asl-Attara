import '../../../../core/database/app_database.dart';

import '../../../../core/database/tables/product_table.dart';

import '../models/product_model.dart';

class ProductLocalDataSource {
  final AppDatabase appDatabase;

  ProductLocalDataSource(this.appDatabase);

  Future<List<ProductModel>> getProducts() async {
    final db = await appDatabase.database;

    final products = await db.query(
      ProductTable.tableName,
      orderBy: '${ProductTable.id} ASC',
    );

    return products.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    final db = await appDatabase.database;

    await db.insert(ProductTable.tableName, product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    final db = await appDatabase.database;

    await db.update(
      ProductTable.tableName,
      product.toJson(),
      where: '${ProductTable.id} = ?',
      whereArgs: [product.id],
    );
  }
}
