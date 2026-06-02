import '../entities/sale_entity.dart';
import '../repositories/sales_repository.dart';

class GetSalesUseCase {
  final SalesRepository repository;

  GetSalesUseCase(this.repository);

  Future<List<SaleEntity>> call() => repository.getSales();
}
