import '../entities/inventory_log_entity.dart';
import '../repositories/inventory_repository.dart';

class GetProductMovementsUseCase {
  final InventoryRepository repository;

  GetProductMovementsUseCase(this.repository);

  Future<List<InventoryLogEntity>> call(int productId) {
    return repository.getProductMovements(productId);
  }
}
