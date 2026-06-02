import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/sales_local_data_source.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/create_sale_use_case.dart';
import '../../domain/usecases/get_today_sales_stats_use_case.dart';
import 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  final CreateSaleUseCase createSaleUseCase;
  final GetTodaySalesStatsUseCase getTodaySalesStatsUseCase;
  final Future<void> Function()? onSaleSaved;

  SalesCubit(
    this.createSaleUseCase,
    this.getTodaySalesStatsUseCase, {
    this.onSaleSaved,
  }) : super(const SalesInitial());

  Future<void> saveSale(List<SaleDraftItem> items) async {
    if (items.isEmpty) {
      emit(const SalesError('أضف منتجا واحدا على الأقل'));
      return;
    }

    final productIds = <int>{};
    for (final item in items) {
      if (item.quantity <= 0) {
        emit(const SalesError('كل الكميات يجب أن تكون أكبر من صفر'));
        return;
      }

      if (item.quantity > item.product.quantity) {
        emit(SalesError('الكمية غير متاحة للمنتج "${item.product.name}"'));
        return;
      }

      if (!productIds.add(item.product.id)) {
        emit(SalesError('المنتج "${item.product.name}" مكرر في عملية البيع'));
        return;
      }
    }

    emit(const SalesLoading());

    try {
      await createSaleUseCase(items);
      await onSaleSaved?.call();
      emit(const SaleSaved());
      await loadTodayStats();
    } on SaleValidationException catch (e) {
      emit(SalesError(e.message));
    } catch (e) {
      emit(const SalesError('تعذر حفظ عملية البيع'));
    }
  }

  Future<void> loadTodayStats() async {
    try {
      final stats = await getTodaySalesStatsUseCase();
      emit(SalesStatsLoaded(stats));
    } catch (e) {
      emit(const SalesError('تعذر تحميل مبيعات اليوم'));
    }
  }
}
