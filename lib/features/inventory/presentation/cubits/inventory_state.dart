import '../../domain/entities/inventory_audit_entity.dart';
import '../../domain/entities/inventory_log_entity.dart';

abstract class InventoryState {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
  const InventoryInitial();
}

class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

class InventoryMovementsLoaded extends InventoryState {
  final List<InventoryLogEntity> movements;

  const InventoryMovementsLoaded(this.movements);
}

class InventoryAuditLoaded extends InventoryState {
  final InventoryAuditEntity audit;

  const InventoryAuditLoaded(this.audit);
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);
}
