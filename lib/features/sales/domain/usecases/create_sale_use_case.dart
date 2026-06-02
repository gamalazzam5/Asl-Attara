import '../entities/sale_entity.dart';
import '../repositories/sales_repository.dart';

class CreateSaleUseCase {
  final SalesRepository repository;

  CreateSaleUseCase(this.repository);

  Future<SaleEntity> call(List<SaleDraftItem> items) {
    return repository.createSale(items);
  }
}
