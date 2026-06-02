import '../entities/sale_stats_entity.dart';
import '../repositories/sales_repository.dart';

class GetTodaySalesStatsUseCase {
  final SalesRepository repository;

  GetTodaySalesStatsUseCase(this.repository);

  Future<SaleStatsEntity> call() => repository.getTodayStats();
}
