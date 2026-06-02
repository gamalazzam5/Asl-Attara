import 'inventory_log_entity.dart';

class InventoryAuditEntity {
  final double openingQuantity;
  final double soldQuantity;
  final double currentQuantity;
  final List<InventoryLogEntity> movements;

  const InventoryAuditEntity({
    required this.openingQuantity,
    required this.soldQuantity,
    required this.currentQuantity,
    required this.movements,
  });
}
