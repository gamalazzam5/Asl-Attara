import '../../domain/entities/sale_entity.dart';
import '../../domain/entities/sale_stats_entity.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasource/sales_local_data_source.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesLocalDataSource localDataSource;

  SalesRepositoryImpl(this.localDataSource);

  @override
  Future<SaleEntity> createSale(List<SaleDraftItem> items) {
    return localDataSource.createSale(items);
  }

  @override
  Future<List<SaleEntity>> getSales() {
    return localDataSource.getSales();
  }

  @override
  Future<SaleStatsEntity> getTodayStats() async {
    final totalSales = await localDataSource.sumToday('totalAmount');
    final totalProfit = await localDataSource.sumToday('totalProfit');

    return SaleStatsEntity(
      totalSalesToday: totalSales,
      totalProfitToday: totalProfit,
    );
  }
}
