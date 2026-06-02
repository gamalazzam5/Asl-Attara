import '../../domain/entities/inventory_audit_entity.dart';
import '../../domain/entities/inventory_log_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasource/inventory_local_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<InventoryLogEntity>> getProductMovements(int productId) {
    return localDataSource.getProductMovements(productId);
  }

  @override
  Future<InventoryAuditEntity> auditProduct({
    required int productId,
    required DateTime from,
    required DateTime to,
    required double currentQuantity,
  }) async {
    final movements = await localDataSource.getProductMovementsBetween(
      productId: productId,
      from: from,
      to: to,
    );

    final soldQuantity = movements
        .where((movement) => movement.changeQuantity < 0)
        .fold<double>(
          0,
          (sum, movement) => sum + movement.changeQuantity.abs(),
        );

    final periodChange = movements.fold<double>(
      0,
      (sum, movement) => sum + movement.changeQuantity,
    );

    return InventoryAuditEntity(
      openingQuantity: currentQuantity - periodChange,
      soldQuantity: soldQuantity,
      currentQuantity: currentQuantity,
      movements: movements,
    );
  }
}
