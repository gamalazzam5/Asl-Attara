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
      if (item.enteredAmount <= 0) {
        emit(const SalesError('أدخل مبلغ البيع لكل منتج'));
        return;
      }

      if (item.product.sellPrice <= 0 || item.calculatedQuantity <= 0) {
        emit(SalesError('سعر البيع غير صحيح للمنتج "${item.product.name}"'));
        return;
      }

      if (item.calculatedQuantity > item.product.quantity) {
        emit(const SalesError('الكمية المطلوبة أكبر من المخزون المتاح'));
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
