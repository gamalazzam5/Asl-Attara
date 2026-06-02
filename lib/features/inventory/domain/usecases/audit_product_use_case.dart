import '../entities/inventory_audit_entity.dart';
import '../repositories/inventory_repository.dart';

class AuditProductUseCase {
  final InventoryRepository repository;

  AuditProductUseCase(this.repository);

  Future<InventoryAuditEntity> call({
    required int productId,
    required DateTime from,
    required DateTime to,
    required double currentQuantity,
  }) {
    return repository.auditProduct(
      productId: productId,
      from: from,
      to: to,
      currentQuantity: currentQuantity,
    );
  }
}
