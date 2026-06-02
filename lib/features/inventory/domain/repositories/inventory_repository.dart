import '../entities/inventory_audit_entity.dart';
import '../entities/inventory_log_entity.dart';

abstract class InventoryRepository {
  Future<List<InventoryLogEntity>> getProductMovements(int productId);

  Future<InventoryAuditEntity> auditProduct({
    required int productId,
    required DateTime from,
    required DateTime to,
    required double currentQuantity,
  });
}
