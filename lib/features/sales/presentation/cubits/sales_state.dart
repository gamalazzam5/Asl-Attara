import '../../domain/entities/sale_stats_entity.dart';

abstract class SalesState {
  const SalesState();
}

class SalesInitial extends SalesState {
  const SalesInitial();
}

class SalesLoading extends SalesState {
  const SalesLoading();
}

class SaleSaved extends SalesState {
  const SaleSaved();
}

class SalesStatsLoaded extends SalesState {
  final SaleStatsEntity stats;

  const SalesStatsLoaded(this.stats);
}

class SalesError extends SalesState {
  final String message;

  const SalesError(this.message);
}
