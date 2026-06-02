import '../../../products/domain/entities/product_entity.dart';
import '../entities/sale_entity.dart';
import '../entities/sale_stats_entity.dart';

abstract class SalesRepository {
  Future<SaleEntity> createSale(List<SaleDraftItem> items);

  Future<List<SaleEntity>> getSales();

  Future<SaleStatsEntity> getTodayStats();
}

class SaleDraftItem {
  final ProductEntity product;
  final double quantity;

  const SaleDraftItem({required this.product, required this.quantity});
}
