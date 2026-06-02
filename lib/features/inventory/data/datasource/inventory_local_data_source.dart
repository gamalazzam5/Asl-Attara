import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/inventory_log_table.dart';
import '../models/inventory_log_model.dart';

class InventoryLocalDataSource {
  final AppDatabase appDatabase;

  InventoryLocalDataSource(this.appDatabase);

  Future<List<InventoryLogModel>> getProductMovements(int productId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      InventoryLogTable.tableName,
      where: '${InventoryLogTable.productId} = ?',
      whereArgs: [productId],
      orderBy: '${InventoryLogTable.createdAt} DESC',
    );

    return rows.map(InventoryLogModel.fromJson).toList();
  }

  Future<List<InventoryLogModel>> getProductMovementsBetween({
    required int productId,
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      InventoryLogTable.tableName,
      where:
          '${InventoryLogTable.productId} = ? AND '
          '${InventoryLogTable.createdAt} >= ? AND '
          '${InventoryLogTable.createdAt} <= ?',
      whereArgs: [
        productId,
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      ],
      orderBy: '${InventoryLogTable.createdAt} DESC',
    );

    return rows.map(InventoryLogModel.fromJson).toList();
  }
}
